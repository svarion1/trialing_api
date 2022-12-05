import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trialing_api/src/data/favourites/database_helper.dart';
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
  int _isFav = 0;
  List<Map<String,dynamic>> myFavourites = [];

  void _refreshFavourites() async {
    myFavourites = await getFavMovies();
    setState(() {
      if(myFavourites.isNotEmpty){
        for(int i = 0; i < myFavourites.length; i++){
          if(myFavourites[i]["id"] == widget.id){
            _isFav = 1;
            _isFavourite = true;
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshFavourites();
  }

  Future<void> addItem() async {
    final Favourite movie = Favourite(
      id: widget.id,
      isFavourite: 1,
    );
    await insertMovie(movie);
    _refreshFavourites();
  }

  Future<void> removeItem() async {
    await deleteMovie(widget.id);
    _refreshFavourites();
  }

  @override
  Widget build(BuildContext context) {



    return IconButton(
      icon: Icon(
       _isFav==1 ? Icons.favorite : Icons.favorite_border,
        color: _isFav==1 ? Colors.red : Colors.white,
      ),
      onPressed: () async {
          addItem();
          setState(() {
            _isFavourite = !_isFavourite;
          });
          insertMovie(Favourite(id: widget.id, isFavourite: _isFavourite ? 1 : 0));

      },

    );
  }

}