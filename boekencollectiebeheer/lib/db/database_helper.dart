import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:boekencollectiebeheer/model/books.dart';

class BookDatabase {
  static final BookDatabase instance = BookDatabase._init();

  static Database? _database;

  BookDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';

    // users tabel
    await db.execute('''
    CREATE TABLE books (
      ${BookFields.id} $idType,
      ${BookFields.title} $textType,
      ${BookFields.author} $textTypeNullable,
      ${BookFields.pages} $textTypeNullable,
      ${BookFields.price} $textTypeNullable
    )
    ''');
  }

  Future<Book> showBook(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'books',
      columns: BookFields.values,
      where: '${BookFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Book.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // Future<Book> showClub(int id) async {
  //   final db = await instance.database;

  //   final maps = await db.query(
  //     'clubs',
  //     columns: ClubFields.values,
  //     where: '${ClubFields.id} = ?',
  //     whereArgs: [id],
  //   );

  //   if (maps.isNotEmpty) {
  //     return Club.fromJson(maps.first);
  //   } else {
  //     throw Exception('ID $id not found');
  //   }
  // }

  Future<List<Book>> showResults(String text) async {
    final db = await instance.database;

    final result = await db.query(
      'books',
      columns: [
        '*',
      ],
      where: '${BookFields.title} like ? OR ${BookFields.author} like ?',
      whereArgs: ['%$text%', '%$text%'],
    );

    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<List<Book>> showAll() async {
    final db = await instance.database;

    final result = await db.query(
      'books',
      columns: [
        '*',
      ],
      orderBy: "title ASC"
    );

    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<void> delete(int id) async {
    final db = await database;

    await db.delete(
      'books',
      where: '${BookFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
