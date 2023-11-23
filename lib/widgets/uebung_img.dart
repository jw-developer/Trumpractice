import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/uebungen_list.dart';


// Übungen Bild anpassen aufgrund der Art

class UebungImg extends StatelessWidget {
  final Map<String, dynamic> uebung;
  final int tonart;
  final int level;

  const UebungImg(
      {super.key,
        required this.uebung,
        required this.tonart,
        required this.level});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      // Prüft, welche Art eine Übung ist (für Quintenzirkel oder chromatisch) und ob das max. Level grösser als 1 ist (fügt Levelzahl bei der Datei an)
        uebung['art'] == 1 && uebung['level'] == 1 ? "assets/${uebung['uebungUrl']}${quintenZirkel[tonart]}.svg" :
        uebung['art'] == 1 && uebung['level'] > 1 ? "assets/${uebung['uebungUrl']}${quintenZirkel[tonart]}$level.svg" :
        uebung['art'] == 2 && uebung['level'] == 1 ? "assets/${uebung['uebungUrl']}${chromatisch[tonart]}.svg" :
        uebung['art'] == 2 && uebung['level'] > 1 ? "assets/${uebung['uebungUrl']}${chromatisch[tonart]}$level.svg" :
        uebung['art'] == 3 && uebung['level'] == 1 ? "assets/${uebung['uebungUrl']}" + art3[tonart] + ".svg" :
        uebung['art'] == 3 && uebung['level'] > 1 ? "assets/${uebung['uebungUrl']}${art3[tonart]}$level.svg" :
        uebung['art'] == 4 && uebung['level'] == 1 ? "assets/${uebung['uebungUrl']}" + art4[tonart] + ".svg" :
        uebung['art'] == 4 && uebung['level'] > 1 ? "assets/${uebung['uebungUrl']}${art4[tonart]}$level.svg" :
        "assets/${uebung['uebungUrl']}uebung$level.svg");
  }
}