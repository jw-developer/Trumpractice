import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:trumpractice/utils/favorits_list.dart';
import 'package:trumpractice/utils/uebungen_list.dart';
import 'package:trumpractice/widgets/favorite_single.dart';
import 'package:trumpractice/widgets/topbar_main.dart';

class Favoriten extends StatelessWidget {
  const Favoriten({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return ListView(
      children: [
        TopBar(title: "Favoriten", orientation: orientation,),

        Gap((orientation == Orientation.portrait ? 40 : 25)),

        Container(
          margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 20 : 50),
          child: Column(children: favorits.map((singleUebung) => FavoriteSingle(uebung: singleUebung, orientation: orientation, backScreen: 1,)).toList()),
        )
      ],
    );
  }
}

// Funktion, welche die Übung zu einer neuen Liste "Favoriten" hinzufügt (nur wichtigste Informationen werden übertragen)
void addToFav(String? kategorie, String? name, String? image, String? uebungUrl, int? art, bool? artikulationsvarianten, int? audio_artikulation, int? artikulationen, int? level, bool? topbarFunc) {
  favorits.add({
    "kategorie": kategorie,
    "name": name,
    "image": image,
    "uebungUrl": uebungUrl,
    "art": art,
    "artikulationsvarianten": artikulationsvarianten,
    "audio_artikulation": audio_artikulation,
    "artikulationen": artikulationen,
    "level": level,
    "topbar_func": topbarFunc,
  });

  saveFavorits();
}

// Funktion, welche die angeglickte Übung wieder aus der "Favoriten" Liste entfernt, indem man nach dem Namen der Übung sucht und das ganze Objekt dann löscht
void removeFromFav(String name) {
  favorits.removeWhere((item) => item["name"] == name);

  final item = uebungenList.firstWhere((element) => element["name"] == name);
  item["isFavorite"] = false;

  saveFavorits();
}

// Funktion, welche alle Favoriten im SharedPrefrences (Android) oder NSUserDefaults (iOS) speichert
void saveFavorits() async {
  SharedPreferences prefs = await SharedPreferences.getInstance(); // erstellt eine Instanz für die Nutzung von SharedPrefrences

  int i = 0; // eine Zählvariaible, die mit der forEach Funktion mitläuft
  for (var singleFav in favorits) {
    await prefs.setString("fav_kategorie_$i",favorits[i]["kategorie"]); // speichert die "Kategorie" der Übung unter dem Key = "fav_kategorie_$i" (Key vom ersten Objekt = "fav_kategorie_1")
    await prefs.setString("fav_name_$i", favorits[i]["name"]);
    await prefs.setString("fav_image_$i", favorits[i]["image"]);
    await prefs.setString("fav_uebungUrl_$i", favorits[i]["uebungUrl"]);
    await prefs.setInt("fav_art_$i", favorits[i]["art"]);
    await prefs.setBool("fav_artikulationsvarianten_$i", favorits[i]["artikulationsvarianten"]);
    await prefs.setInt("fav_audio_artikulation_$i", favorits[i]["audio_artikulation"]);
    await prefs.setInt("fav_artikulationen_$i", favorits[i]["artikulationen"]);
    await prefs.setInt("fav_level_$i", favorits[i]["level"]);
    await prefs.setBool("fav_topbar_func_$i", favorits[i]["topbar_func"]);

    i++;
  }
  await prefs.setInt("fav_length", i); // speichert die Anzahl der Favoriten im SharedPrefrences
}

// Funktion, mit welcher alle Zwischengespeicherten Daten über die Favoriten wieder in die Liste "favorits" hinzugefügt werden
void getFavorits() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  int favLength = prefs.getInt("fav_length")!.toInt();

  int i = 0;
  while (i < favLength) {
    String? favKategorie = prefs.getString('fav_kategorie_$i');
    String? favName = prefs.getString('fav_name_$i');
    String? favImage = prefs.getString('fav_image_$i');
    String? favUebungUrl = prefs.getString('fav_uebungUrl_$i');
    int? favArt = prefs.getInt('fav_art_$i');
    bool? favArtikulationsvarianten = prefs.getBool('fav_artikulationsvarianten_$i');
    int? favAudioArtikulation = prefs.getInt('fav_audio_artikulation_$i');
    int? favArtikulationen = prefs.getInt('fav_artikulationen_$i');
    int? favLevel = prefs.getInt('fav_level_$i');
    bool? favTopBarFunc = prefs.getBool('fav_topbar_func_$i');

    if(favorits.any((element) => element.values.contains(favName)) == false) {
      addToFav(favKategorie, favName, favImage, favUebungUrl,
          favArt, favArtikulationsvarianten, favAudioArtikulation, favArtikulationen,  favLevel, favTopBarFunc);
    }

    final item =
    uebungenList.firstWhere((element) => element["name"] == favName);
    item["isFavorite"] = true;
    i++;
  }
}
