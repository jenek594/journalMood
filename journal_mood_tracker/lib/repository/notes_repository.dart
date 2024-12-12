
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
          'CREATE TABLE $_tablename(id INTEGER PRIMARY KEY, title TEXT, description TEXT, createdAt TEXT, moodIndex INTEGER)',
        );
      },
      version: 1,
    );
    return database;
  }

  static insert({required Note note}) async{
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
    await db.delete(
      _tablename, 
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }  



  static Future<List<Note>> getNotes() async{
    final db = await _database();

    final List<Map<String, dynamic>> maps = await db.query(_tablename);
    return [
      for (final {
            'id': id as int,
            'title': title as String,
            'description': description as String,
            'createdAt': createdAt as String,
            'moodIndex': moodIndex as int
          } in maps)
        Note(id:id, title: title, description: description, createdAt: DateTime.parse(createdAt), moodIndex: moodIndex),
    ];
  }
}