

import 'package:flutter/material.dart';
import 'package:journal_mood_tracker/camera.dart';
import 'package:journal_mood_tracker/models/note.dart';
import 'package:journal_mood_tracker/providers/notes/notes_provider.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  final bool? isMoodIndex;
  const AddNoteScreen({super.key, this.note, this.isMoodIndex});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  int moodIndex = 0;

  @override
  void initState() {
    if (widget.note != null){
      _title.text = widget.note!.title;
      _description.text = widget.note!.description;
    }
    super.initState();
  }
  

  @override
  void didChangeDependencies() {
    if (widget.isMoodIndex != null){
    moodIndex = Provider.of<int>(context, listen: false);      
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить запись'),
        actions: [
          IconButton(
            onPressed:_deleteNote, 
            icon: Icon(Icons.delete)),
          IconButton(
            onPressed: (){
              (widget.note == null)? _insertNote() : _updateNote();
            },
            icon: const Icon(Icons.done))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                hintText: 'Назавние',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i<5; i++)
                  IconButton(
                    onPressed: (){
                      moodIndex = i;
                    }, 
                    icon: Text(i.toString())
                  )
              ],
            ),
            SizedBox(height: 15,),
            Align(
              alignment: Alignment.centerLeft,
              child: const Imagecontainer(),
            ),
            SizedBox(height: 15,),
            Expanded(
              child: TextField(
                controller: _description,
                decoration: InputDecoration(
                  hintText: 'Напшите свои мысли тут...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  )
                ),
                maxLines: 50,
              ),
            ),
            // photo

          ],
        ),
      ),
    );
  }


  _insertNote(){
    final note = Note(
    title: _title.text, 
    description: _description.text, 
    createdAt: DateTime.now(),
    moodIndex: moodIndex
    );
    Provider.of<NotesProvider>(context, listen: false).insert(note: note).then((e){
      Navigator.pop(context);      
    }); 

  }
  _updateNote(){
    final note = Note(
      id: widget.note!.id,
      title: _title.text, 
      description: _description.text, 
      createdAt: widget.note!.createdAt, 
      moodIndex: moodIndex
    );
    Provider.of<NotesProvider>(context, listen: false).update(note: note).then((e){
      Navigator.pop(context);
    });  
  }

  _deleteNote(){
    if (widget.note != null){
      Provider.of<NotesProvider>(context, listen: false).delete(note: widget.note!).then((e){
      Navigator.pop(context);
    });
    }
  }
}