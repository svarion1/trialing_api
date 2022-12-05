
import 'package:html/parser.dart';

class MovieModel {
  int id;
  String name;
  List<String> genre;
  Image image;
  String url;
  String year;
  String summary;
  String rating;
  String status;

  MovieModel(
      {required this.id,
        required this.name,
        required this.genre,
        required this.image,
        required this.url,
        required this.summary,
        required this.year,
        required this.rating,
        required this.status});

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    var genres = json['genres'];
    List<String> genreList = genres.cast<String>();
    return MovieModel(
        id: json['id'],
        name: json['name'],
        genre: genreList,
        image: Image.fromJson(json['image']),
        url: json['url'],
        year: json['premiered'],
        rating: json['rating']['average'] != null
            ? json['rating']['average'].toString()
            : 'N/A',
        status: json['status'],
        summary: parse(json['summary']).documentElement!.text);


  }


}

class Image {
  String original;
  String medium;

  Image({required this.medium, required this.original});

  factory Image.fromJson(Map<String, dynamic> imagejson) {
    return Image(medium: imagejson['medium'], original: imagejson['original']);
  }
}