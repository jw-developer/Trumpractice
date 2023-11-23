import 'package:flutter/material.dart';

import '../uebung.dart';
import '../utils/device_info.dart';
import '../utils/styles.dart';

class UebungPreview extends StatelessWidget {
  final Map<String, dynamic> uebung;
  final Orientation orientation;
  const UebungPreview({super.key, required this.uebung, required this.orientation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Uebung(uebung: uebung, backScreen: 0,),
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
      }),

      child: Container(
        // Styling der "ÜbungPreview" Kachel
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 150 : 200,
        height: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 150 : 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Styles.textColor,
              width: 1,
            )),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bild/Symbol Vorschau der Übung
              Image.asset(
                uebung["image"],
                width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 100 : 150,
              ),
              // Name der Übung
              FittedBox(
                fit: BoxFit.contain,
                child: Text(uebung["name"], style: TextStyle(fontWeight: FontWeight.w500, fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 16 : 20),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
