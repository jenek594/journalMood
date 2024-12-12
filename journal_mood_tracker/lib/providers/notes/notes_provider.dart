import 'package:flutter/material.dart';
import 'package:journal_mood_tracker/models/note.dart';
import 'package:journal_mood_tracker/repository/notes_repository.dart';

class NotesProvider with ChangeNotifier{
  List<Note> notes = [];

  NotesProvider(){
    getNotes();
  }
  
  getNotes() async {
    notes = await NotesRepository.getNotes();
    notifyListeners();
  }


  insert({required Note note}) async {
    await NotesRepository.insert(note: note);  
    getNotes();
  }

  update({required Note note}) async {
    await NotesRepository.update(note: note);
    getNotes();
  }

  delete({required Note note}) async {
    await NotesRepository.delete(note: note);
    getNotes();
  }  
}