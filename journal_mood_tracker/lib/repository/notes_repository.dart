
import 'package:flutter/foundation.dart';
import 'package:journal_mood_tracker/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesRepository {

  static const _dbName = 'notes_database.db';
  static const _tablename = 'notes';


  static Future<Database> _database() async {
    final database = openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tablename(id INTEGER PRIMARY KEY, title TEXT, description TEXT, createdAt TEXT, moodIndex INTEGER, image BLOB)',
        );
      },
      version: 1,
    );
    return database;
  }

  static insert({required Note note}) async {
    final db = await _database();
    await db.insert(
      _tablename,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static update({required Note note}) async {
    final db = await _database();
    await db.update(
      _tablename,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static delete({required Note note}) async {
    final db = await _database();
    await db.rawDelete('DELETE FROM $_tablename WHERE id = ? ', [note.id]);
  } 



  static Future<List<Note>> getNotes() async{
  final db = await _database();

  final List<Map<String, dynamic>> maps = await db.query(_tablename);
  return [
    for (final map in maps)
      Note(
        id: map['id'] as int,
        title: map['title'] as String,
        description: map['description'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        moodIndex: map['moodIndex'] as int,
        image: map['image'] != null ? map['image'] as Uint8List : null,
      ),
  ];
}

}