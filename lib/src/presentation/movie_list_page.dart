import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:trialing_api/src/data/favourites/favourite_model.dart';
import 'package:trialing_api/src/presentation/widgets/movie_card.dart';
import "package:trialing_api/src/data/movie_model.dart" as Image;
import '../data/movie_model.dart';
import 'detail_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class MovieListPage extends StatefulWidget {
  final String title;
  const MovieListPage({Key? key, required this.title}) : super(key: key);

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late Future<List<MovieModel>> futureMovies;
  bool _loading = true;

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


  @override
  void initState() {
    super.initState();
    getMovies();

  }

  getMovies() async {
    futureMovies = fetchMovies();
    _loading = false;
  }

  Future<List<MovieModel>> fetchMovies() async {
    String tvmazeUrl = "https://api.tvmaze.com/shows";
    final response = await http.get(Uri.parse(tvmazeUrl));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load show data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        elevation: 4,
        title: Center(child: Text(widget.title, style: GoogleFonts.raleway(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.redAccent, letterSpacing: 2) )),
        backgroundColor: Colors.black87,
      ),

      body: FutureBuilder<List<MovieModel>>(
              future: futureMovies,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return MovieCard(
                              title: snapshot.data![index].name.toString(),
                              showImage: snapshot.data![index].image.medium,
                              summary: snapshot.data![index].summary.toString(),
                              id: snapshot.data![index].id,
                              rating: snapshot.data![index].rating,
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(id: snapshot.data![index].id)));
                              },
                            );
                          }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.8,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                       ),
                            ) ,


                      );


                } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                return const Center(child: CircularProgressIndicator());
              },

    ),




    );



  }
}