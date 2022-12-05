import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'favourite_model.dart';

Future<void> createTables(Database database) async {
    await database.execute(
      """CREATE TABLE favourite_movies(id INTEGER PRIMARY KEY, isFavourite INTEGER)""",
    );
}

Future<Database> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), "movies_database.db"),
      onCreate: (db, version) async{
        return await createTables(db);
      },
      version: 1,
    );
    return database;
}

Future<void> insertMovie(Favourite movie) async {
    final Database db = await main();

    await db.insert(
      'favourite_movies',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
}

Future<List<Map<String, dynamic>>> getFavMovies() async {
    final Database db = await main();

    return db.query("favourite_movies", orderBy: "id");
}

Future<void> deleteMovie(int id) async {
    final Database db = await main();

   try { await db.delete(
     'favourite_movies',
     where: "id = ?",
     whereArgs: [id],
   );} catch (e) {
     print("Something went wrong when deleting the movie: ${e}");
   }
}
