
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'models/movie.dart';

class DatabaseHelper {

  static final _databaseName = "Movies.db";
  static final _databaseVersion = 1;

  static final table = 'movies';

  static final imdbId = '_imdbId';
  static final poster = 'poster';
  static final title = 'title';
  static final director = 'director';
  static final year = 'year';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $imdbId TEXT PRIMARY KEY,
            $poster TEXT NOT NULL,
            $title TEXT NOT NULL,
            $year TEXT NOT NULL,
            $director TEXT NOT NULL
          )
          ''');
    await db.rawInsert('INSERT INTO $table ($imdbId, $poster, $title, $year, $director) VALUES("tt4853102", "https://m.media-amazon.com/images/M/MV5BMTdjZTliODYtNWExMi00NjQ1LWIzN2MtN2Q5NTg5NTk3NzliL2ltYWdlXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SX300.jpg","Batman","2016","Aakash Bhagat")');
    await db.rawInsert('INSERT INTO $table ($imdbId, $poster, $title, $year, $director) VALUES("tt0106364", "https://m.media-amazon.com/images/M/MV5BYTRiMWM3MGItNjAxZC00M2E3LThhODgtM2QwOGNmZGU4OWZhXkEyXkFqcGdeQXVyNjExODE1MDc@._V1_SX300.jpg", "Batman: Mask of the Phantasm","1993","Sunny Mevawala")');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Movie>> queryAllRows() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Movie(
        imdbId: maps[i]["_imdbId"],
        poster: maps[i]["poster"],
        title: maps[i]["title"],
        year: maps[i]["year"],
        director: maps[i]["director"],
      );
    });
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<Movie> queryMovie(id) async {
    Database db = await instance.database;
    var result = await db.query(table, where: '$imdbId = ?', whereArgs: [id]);
    return Movie(
        imdbId: result.first["_imdbId"],
        poster: result.first["poster"],
        title: result.first["title"],
        year: result.first["year"],
        director: result.first["director"],
    );
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[imdbId];
    return await db.update(table, row, where: '$imdbId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$imdbId = ?', whereArgs: [id]);
  }
}