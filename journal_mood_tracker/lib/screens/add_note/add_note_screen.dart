

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unused_import
import 'package:journal_mood_tracker/camera.dart';
import 'package:journal_mood_tracker/models/note.dart';
import 'package:journal_mood_tracker/photo_container.dart';
import 'package:journal_mood_tracker/providers/notes/notes_provider.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  final int? isMoodIndex;
  const AddNoteScreen({super.key, this.note, this.isMoodIndex});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  int moodIndex = 0;
  int _selectedIndex = -1;
  XFile? _selectedImage;

  @override
  void initState() {
    if (widget.note != null){
      _selectedIndex = widget.note!.moodIndex;
      _title.text = widget.note!.title;
      _description.text = widget.note!.description;
    }
    super.initState();
  }
  

  @override
  void didChangeDependencies() {
    if (widget.isMoodIndex != null){
    moodIndex = Provider.of<int>(context, listen: false);
     _selectedIndex = moodIndex;      
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
                labelText: 'Дайте заголовок этому дню',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedIndex == index) {
                                _selectedIndex = -1;
                              } else {
                                _selectedIndex = index;
                              }
                            });
                          },
                          child: Container(
                            width: _selectedIndex == index? 70 : 50,
                            height:  _selectedIndex == index? 70 : 50,
                            decoration: BoxDecoration(
                              color: _selectedIndex == index ? Colors.blue : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset('assets/mood_$index.png'),
                          )
                        );
                      }),
            ),
            // photo
            SizedBox(height: 15,),
            (widget.note != null && widget.note!.image != null)?
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  //TODO decor
                  child: ImageHelper.imageFromBytes(widget.note!.image!),
                ),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child:  Imagecontainer(
                  onImageSelected: (XFile? image) {
                    _selectedImage = image;
                  },
                ),
              ),
            SizedBox(height: 15,),
            Expanded(
              child: TextField(
                controller: _description,
                decoration: InputDecoration(
                  labelText:  'Напишите свои мысли тут',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  )
                ),
                maxLines: 50,
              ),
            ),

          ],
        ),
      ),
    );
  }


  _insertNote() async {
    if (_selectedImage != null) {
      File file = File(_selectedImage!.path);
      Uint8List imageBytes = await file.readAsBytes();
      final note = Note(
        title: _title.text,
        description: _description.text,
        createdAt: DateTime.now(),
        moodIndex: _selectedIndex,
        image: imageBytes,
      );
      Provider.of<NotesProvider>(context, listen: false)
          .insert(note: note)
          .then((e) {
        Navigator.pop(context);
      });
    } else {
      final note = Note(
        title: _title.text,
        description: _description.text,
        createdAt: DateTime.now(),
        moodIndex: _selectedIndex,
      );
      Provider.of<NotesProvider>(context, listen: false)
          .insert(note: note)
          .then((e) {
        Navigator.pop(context);
      });
    }
  }
  _updateNote(){
    final note = Note(
      id: widget.note!.id,
      title: _title.text, 
      description: _description.text, 
      createdAt: widget.note!.createdAt, 
      moodIndex: _selectedIndex
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

class ImageHelper {
  static Widget imageFromBytes(Uint8List bytes) {
    return Image.memory(bytes);
  }
}