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
              var summary = parse(snapshot.data!.summary);
              var rating = double.parse(snapshot.data!.rating.toString());

              return Scaffold(
                backgroundColor: Colors.grey,

                appBar: AppBar(
                  elevation: 4,

                  title: Text(snapshot.data!.name.toString(), style: GoogleFonts.raleway(fontSize: 24, fontWeight: FontWeight.w300),),
                  backgroundColor: Colors.black87,
                ),
                body:  SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.Image.network(snapshot.data!.image.original.toString(), fit: BoxFit.cover, height: 300, width: double.infinity, alignment: Alignment.topCenter,),
                            Positioned(right: 10, top: 15,child: Row(children: [Chip(label: Text(snapshot.data!.genre[0]), backgroundColor: Colors.white24,),SizedBox(width: 5,),Chip(label: Text(snapshot.data!.genre[1]), backgroundColor: Colors.white24,),],)
                            ) ,
                            Positioned(left: 10, top: 15,child: Chip(label: Text(snapshot.data!.status), backgroundColor: snapshot.data!.status=="Ended"? Colors.red : Colors.lightGreenAccent,),) ,
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, ),
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
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text("Summary", style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.w700),),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(summary.body!.text, style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w300, color: Colors.white), textAlign: TextAlign.left,),
                        ),
                        const SizedBox(height: 10,),

                      ],
                    ),
                  ),


              );

            } else {
              return const Center(child: CircularProgressIndicator());
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

    int ratingInt = rating.round();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(10, (index) {
        return Icon(
          index+1 <= ratingInt ? Icons.star : Icons.star_border_outlined,
          color: Colors.orange,
        );
      }),
    );
  }




}

