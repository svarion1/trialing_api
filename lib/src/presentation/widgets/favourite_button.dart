import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/favourites/favourite_model.dart';


class FavouriteButton extends StatefulWidget {
  final Function(bool) onFavouriteChanged;
  final int id;

  const FavouriteButton({
     Key? key,
    required this.id,
    required this.onFavouriteChanged,
  }) : super(key: key);

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  bool _isFavourite = false;

  Future<Database> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), "movies_database.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE movies(id INTEGER PRIMARY KEY, showId TEXT, isFavourite BOOLEAN)",
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertMovie(Favourite movie) async {
    final Database db = await main();

    await db.insert(
      'movies',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Favourite>> movies() async {
    final Database db = await main();

    final List<Map<String, dynamic>> maps = await db.query('movies');

    return List.generate(maps.length, (i) {
      return Favourite(
        id: maps[i]['id'],
        showId: maps[i]['showId'],
        isFavourite: maps[i]['isFavourite'],
      );
    });
  }



  @override
  Widget build(BuildContext context) {

    var fav = movies();

    return IconButton(
      icon: Icon(
       _isFavourite ? Icons.favorite : Icons.favorite_border,
        color: _isFavourite ? Colors.red : Colors.white,
      ),
      onPressed: () async {

          setState(() {
            _isFavourite = !_isFavourite;
          });
          await insertMovie(Favourite(id: widget.id, showId: widget.id, isFavourite: _isFavourite));

      },

    );
  }

}