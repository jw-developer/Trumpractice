import 'package:flutter/material.dart';

import '../favoriten.dart';

class FavoriteIcon extends StatefulWidget {
  final Map<String, dynamic> uebung;
  final Color color;
  const FavoriteIcon({super.key, required this.uebung, required this.color});

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (widget.uebung["isFavorite"] == false) {
          setState(() {
            widget.uebung["isFavorite"] = true;
          });
          addToFav(
              widget.uebung["kategorie"],
              widget.uebung["name"],
              widget.uebung["image"],
              widget.uebung["uebungUrl"],
              widget.uebung["art"],
              widget.uebung["artikulationsvarianten"],
              widget.uebung["audio_artikulation"],
              widget.uebung['artikulationen'],
              widget.uebung["level"],
              widget.uebung["topbar_func"]);

        } else {
          setState(() {
            widget.uebung["isFavorite"] = false;
            removeFromFav(widget.uebung["name"]);
          });
        }

      },
      icon: Icon(
        widget.uebung["isFavorite"] == false
            ? Icons.favorite_outline
            : Icons.favorite,
        color: widget.color,
      ),
    );
  }
}