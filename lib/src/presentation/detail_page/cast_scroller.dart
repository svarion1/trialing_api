import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trialing_api/src/data/cast_model.dart';
import "package:flutter/src/widgets/image.dart" as Image;

class CastScroller extends StatelessWidget {
  const CastScroller({Key? key, required this.actorList}) : super(key: key);
  final List<CastModel> actorList;

  Widget _buildActor(BuildContext context, int index){
   var actor = actorList[index];
    return Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(actor.person.image.medium),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(actor.person.name),
            )
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Cast",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(120.0),
          child: ListView.builder(
            itemCount: actorList!.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            itemBuilder: _buildActor,
          )
        )
      ],
    );
  }
}
