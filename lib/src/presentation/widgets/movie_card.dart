import 'package:flutter/material.dart';
import 'package:trialing_api/src/data/movie_model.dart';
import "package:flutter/src/widgets/image.dart" as Image;
import 'package:google_fonts/google_fonts.dart';

class MovieCard extends StatelessWidget {

  final String showImage, title, summary, rating;
  final int id;
  List<String> genres = [];
  final VoidCallback onTap;

  MovieCard(
      {Key? key,
        required this.showImage,
        required this.title,
        required this.id,
        required this.summary,
        required this.onTap,
        required this.rating,
      })
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 180,
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Image.Image.network(showImage, fit: BoxFit.cover)
                          ),
                        ),
                      ),
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                             bottomLeft: Radius.circular(5),
                             bottomRight: Radius.circular(5),
                           ),
                          color: Colors.black.withOpacity(0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                           ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                                 child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                        Row(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Expanded(
                                               child: Wrap(
                                                  children: [
                                                        Text(title,style: GoogleFonts.raleway(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 2,),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        Text(summary,style: GoogleFonts.raleway(fontSize: 14, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 3,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                Positioned(
                  top: 0,
                  right: 5,

                  child: Chip(
                    backgroundColor: Colors.black.withOpacity(0.3),
                    label: Wrap(
                      spacing: 2,
                      children: [Text(
                        rating,
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),

                      ),
                        const Icon(Icons.star, color: Colors.yellow, size:16)]
                    ),
                  ),
                ),
                          ],
                        ),
                      ),
                    ),
    );
      }

}