// ignore_for_file: unnecessary_this, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notesapp/db/notes_database.dart';
import 'package:notesapp/model/note.dart';
import 'package:notesapp/pages/add_edit_note_page.dart';
import 'package:notesapp/pages/note_detail_page.dart';
import 'package:notesapp/widgets/note_cart_widget.dart';
import 'package:notesapp/widgets/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class NotePageState extends StatefulWidget {
  NotePageState({Key? key}) : super(key: key);

  @override
  State<NotePageState> createState() => _NotePageState();
}

class _NotePageState extends State<NotePageState> {
  late List<Note> notes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  @override
  void dispose() {
    NoteDatabase.instance.close();

    super.dispose();
  }

  Future refreshNote() async {
    setState(() => _isLoading = true);
    this.notes = await NoteDatabase.instance.readAll();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Notes".text.xl3.white.make(),
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey.shade900,
          child: Column(
            children: [
              
              80.heightBox,
              
              "Made By".text.white.xl3.semiBold.make().p(16),
              "Achintya".text.white.bold.xl4.make().shimmer(
                  primaryColor: Vx.pink500, secondaryColor: Vx.blue500),
              
              20.heightBox,
              
              ElevatedButton(onPressed: () {
                    launch("https://linktr.ee/achintya_only");
                  },
                   child: "Link Tree".text.white.make(),
                   style: ElevatedButton.styleFrom(
                     primary: Colors.greenAccent,
                     padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                     textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70)
                   ),
              ),

              IconButton(onPressed: () {
                launch("https://github.com/achintya-7/notesApp_flutter");
              }, icon: Image.asset('assets/images/icons8-github-96.png'), iconSize: 80)
            
            ]
          ),
        ),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : notes.isEmpty
                ? Text(
                    'No Notes',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditNotePage()),
          );

          refreshNote();
        },
      ),
    );
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        padding: EdgeInsets.all(8),
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNote();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
