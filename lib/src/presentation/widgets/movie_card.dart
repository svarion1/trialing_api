import 'package:flutter/material.dart';
import 'package:trialing_api/src/data/movie_model.dart';
import "package:flutter/src/widgets/image.dart" as Image;

class MovieCard extends StatelessWidget {

  final String showImage, title, summary;
  final int id;
  List<String> genres = [];
  final onTap;

  MovieCard(
      {Key? key,
        required this.showImage,
        required this.title,
        required this.id,
        required this.summary,
        required this.onTap,
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
                                                        Text(title,style: const TextStyle(color: Colors.white,fontSize: 32,)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        Text(summary,style: const TextStyle( color: Colors.white, fontSize:12),overflow: TextOverflow.ellipsis,maxLines: 2,)
                                      ],
                                    ),
                                  ),
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