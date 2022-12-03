import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:trialing_api/src/data/movie_model.dart';
import "package:flutter/src/widgets/image.dart" as Image;
import 'package:trialing_api/src/presentation/detail_page/cast_scroller.dart';
import '../data/cast_model.dart';

class DetailPage extends StatefulWidget {
  final MovieModel movie2;
  const DetailPage({Key? key, required this.movie2}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<CastModel>> futureCast ;
  late double test;
  @override
  void initState() {

    super.initState();

    getCast();

     test = double.parse(widget.movie2.rating);
  }

  getCast() async {
    futureCast = fetchCast();
  }


  Future<List<CastModel>> fetchCast() async {
    String tvmazeUrl = "https://api.tvmaze.com/shows/${widget.movie2.id}/cast";
    final response = await http.get(Uri.parse(tvmazeUrl));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((e) => CastModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load show data');
    }
  }


  @override
  Widget build(BuildContext context) {
    var genres = widget.movie2.genre;

    return
      Scaffold(
        appBar: AppBar(
          title: Text(widget.movie2.name, style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  ))),
        ),
        body: Column(
          children: [
            Stack(
                children: [
                  Image.Image.network(widget.movie2.image.original, fit: BoxFit.cover, height: 300, width: double.infinity, alignment: Alignment.topCenter,),
                  Positioned(right: 10, top: 15,child: Row(children: [
                    genres.length < 2 ? Chip(label: Text(genres[0])) : Row(
                      children: [
                        Chip(label: Text(genres[0])),
                        const SizedBox(width: 5,),
                        Chip(label: Text(genres[1])),
                        ],
                      ),
                    ],
                  )
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FutureBuilder<List<CastModel>?>(
                future: futureCast,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return CastScroller(actorList: snapshot.data!);
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            RatingBar(rating: test),


            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.movie2.summary, style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w400),),
            ),
            const Spacer(),
          ],
        ),
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

