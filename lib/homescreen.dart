import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:trumpractice/utils/device_info.dart';
import 'package:trumpractice/utils/styles.dart';
import 'package:trumpractice/utils/uebungen_list.dart';
import 'package:trumpractice/widgets/topbar_main.dart';
import 'package:trumpractice/widgets/uebung_preview.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  // Unterlisten von der grossen "uebungenList" mit allen Kategorien zu Listen der einzelnen Kategorien
  final einspielenListe = uebungenList.where((element) => element["kategorie"] == "Einspielen");
  final technikListe = uebungenList.where((element) => element["kategorie"] == "Technik");
  final flexibilitaetListe = uebungenList.where((element) => element["kategorie"] == "Flexibilität");

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return ListView(
      children: [
        TopBar(title: "Trumpractice", orientation: orientation,), // custom AppBar

        Gap((orientation == Orientation.portrait ? 40 : 25)),

        // horizontales Scrollfeld für Kategorie 1 = Einspielen
        Container(
          margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 20 : 50),
          alignment: orientation == Orientation.portrait ? Alignment.center : Alignment.center,
          decoration: BoxDecoration(
            color: Styles.whiteColor,
          ),

          child: Text("Einspielen", style: Styles.h2.copyWith(fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 24 : 32),) // Überschrift der Kategorie
        ),

        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 10 : 40),
              child: Row(
                children: einspielenListe.map((singleUebeung) => UebungPreview(uebung: singleUebeung, orientation: orientation,)).toList(), // ein Vorschaubild und der Name der Übung
              ),
            ),
          ),
        ),

        const Gap(25),

        // horizontales Scrollfeld für Kategorie 2 = Technik
        Container(
            margin: EdgeInsets.symmetric(horizontal:orientation == Orientation.portrait ? 20 : 50),
            alignment: orientation == Orientation.portrait ? Alignment.center : Alignment.center,
            child: Text("Technik", style: Styles.h2.copyWith(fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 24 : 32),) // Überschrift der Kategorie
        ),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 10 : 40),
              child: Row(
                children: technikListe.map((singleUebeung) => UebungPreview(uebung: singleUebeung, orientation: orientation)).toList(), // ein Vorschaubild und der Name der Übung
              ),
            ),
          ),
        ),

        const Gap(25),

        // horizontales Scrollfeld für Kategorie 3 = Flexibilität
        Container(
            margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 20 : 50),
            alignment: orientation == Orientation.portrait ? Alignment.center : Alignment.center,
            child: Text("Flexibilität", style: Styles.h2.copyWith(fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 24 : 32),) // Überschrift der Kategorie
        ),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 10 : 40),
              child: Row(
                children: flexibilitaetListe.map((singleUebeung) => UebungPreview(uebung: singleUebeung, orientation: orientation)).toList(), // ein Vorschaubild und der Name der Übung
              ),
            ),
          ),
        ),
      ],
    );
  }
}
