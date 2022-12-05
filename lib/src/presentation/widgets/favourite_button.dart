

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FavouriteButton extends StatelessWidget {
  final bool isFavourite;
  final Function(bool) onFavouriteChanged;
  final int id;

  const FavouriteButton({
     Key? key,
    required this.id,
    required this.isFavourite,
    required this.onFavouriteChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavourite ? Icons.favorite : Icons.favorite_border,
        color: isFavourite ? Colors.red : Colors.white,
      ),
      onPressed: () => onFavouriteChanged(!isFavourite),
    );
  }
}