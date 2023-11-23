import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../uebung.dart';
import '../utils/device_info.dart';
import '../utils/styles.dart';
import 'favorite_icon.dart';

class FavoriteSingle extends StatefulWidget {
  final Map<String, dynamic> uebung;
  final int backScreen;
  final Orientation orientation;

  const FavoriteSingle({super.key, required this.uebung, required this.orientation, required this.backScreen});

  @override
  State<FavoriteSingle> createState() => _FavoriteSingleState();
}

class _FavoriteSingleState extends State<FavoriteSingle> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Navigiert zu der passenden Übungsseite
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Uebung(
            uebung: widget.uebung, backScreen: widget.backScreen,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ));
      },

      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: DeviceInfo.width(context) < DeviceInfo.breakpoint1(widget.orientation) ? 0 : 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Styles.textColor,
              width: 1,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Vorschaubild der Übung ganz Links
                Image.asset(
                  widget.uebung["image"],
                  width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(widget.orientation) ? 30  : 50,
                ),
                const Gap(5),
                // Kategorie und Name der Übung
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.uebung["kategorie"],
                      style:
                      Styles.h4.copyWith(fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(widget.orientation) ? 14 : 18, color: Colors.grey),
                    ),
                    Text(
                      widget.uebung["name"],
                      style: DeviceInfo.width(context) < DeviceInfo.breakpoint1(widget.orientation) ? Styles.h4 : Styles.h2,
                    ),
                  ],
                ),
              ],
            ),

            // Übung als Favorit markieren ja/nein
            FavoriteIcon(uebung: widget.uebung, color: Styles.textColor)
          ],
        ),
      ),
    );
  }
}