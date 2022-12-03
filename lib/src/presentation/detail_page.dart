import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:trialing_api/src/data/movie_model.dart';
import "package:flutter/src/widgets/image.dart" as Image;
import 'package:trialing_api/src/presentation/detail_page/cast_scroller.dart';
import '../data/cast_model.dart';

class DetailPage extends StatefulWidget {

  final int id;
  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<CastModel>> futureCast ;
  late Future<MovieModel> futureMovie;


  @override
  void initState() {

    super.initState();
    getDetail();
    getCast();

  }

  getCast() async {
    futureCast = fetchCast();
  }
  getDetail() async {
    futureMovie = fetchMovie();
  }

  Future<List<CastModel>> fetchCast() async {
    String tvmazeUrl = "https://api.tvmaze.com/shows/${widget.id}/cast";
    final response = await http.get(Uri.parse(tvmazeUrl));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((e) => CastModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load show data');
    }
  }

  Future<MovieModel> fetchMovie() async {
    String tvmazeUrl = "https://api.tvmaze.com/shows/${widget.id}";
    final response = await http.get(Uri.parse(tvmazeUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return MovieModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load show data');
    }
  }



  @override
  Widget build(BuildContext context) {


    return
      FutureBuilder(
          future: futureMovie,
          builder: (context, snapshot) {
            if (snapshot.hasData){
              var summary = parse("""${snapshot.data!.summary}""");
              var rating = double.parse(snapshot.data!.rating.toString());

              return Scaffold(
                appBar: AppBar(
                  title: Text(snapshot.data!.name.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center, ),
                ),
                body: Column(
                  children: [
                    Stack(
                        children: [
                          Image.Image.network(snapshot.data!.image!.original.toString(), fit: BoxFit.cover, height: 300, width: double.infinity, alignment: Alignment.topCenter,),
                          Positioned(right: 10, top: 15,child: Row(children: [Chip(label: Text(snapshot.data!.genre![0]), backgroundColor: Colors.white24,),Chip(label: Text(snapshot.data!.genre![1]), backgroundColor: Colors.white24,),],)) ,]),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: FutureBuilder<List<CastModel>?>(
                        future: futureCast,
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            return CastScroller(actorList: snapshot.data!);
                          }else{
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    RatingBar(rating: rating,),


                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(summary.body!.text, style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w400),),

                    ),
                    const Spacer(),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
      );

    }

  }

class RatingBar extends StatelessWidget {
  double rating;

  RatingBar({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(10, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border_outlined,
          color: Colors.orange,
        );
      }),
    );
  }




}

