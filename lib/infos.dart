import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:trumpractice/utils/device_info.dart';
import 'package:trumpractice/utils/styles.dart';
import 'package:trumpractice/utils/uebungen_list.dart';
import 'package:trumpractice/widgets/favorite_single.dart';
import 'package:trumpractice/widgets/topbar_main.dart';
import 'package:url_launcher/url_launcher.dart';

class Infos extends StatelessWidget {
  const Infos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return ListView(
      children: [
        TopBar(title: "Infos", orientation: orientation,),

        Gap((orientation == Orientation.portrait ? 40 : 25)),

        Container(
            margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 20 : 50),

            child: Column(
              children: [
                // Informationstext

                // Beschreibung
                Text('"Trumpractice" ist ein Trompetencoach mit Übungen zur Unterstützung beim Trompetespielen.', style: Styles.textStyle.copyWith(fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 16 : 20), textAlign: TextAlign.center,),
                const Gap(5),

                // Webseite Link
                TextButton.icon(
                  onPressed: () {
                    Uri url = Uri.parse("https://www.trumpractice.ch");
                    launchUrl(url);
                  },
                  icon: Icon(Icons.link, color: Styles.textColor,),
                  label: Text("https://www.trumpractice.ch", style: TextStyle(fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 16 : 20, color: Styles.mainColor, fontWeight: FontWeight.w400,)),
                ),

                // E-Mail Link
                TextButton.icon(
                  onPressed: () {
                    Uri url = Uri.parse("mailto:janis.wiederkehr@ksh.edu");
                    launchUrl(url);
                  },
                  icon: Icon(Icons.mail_outline, color: Styles.textColor,),
                  label: Text("Support E-Mail-Adresse", style: TextStyle(fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 16 : 20, color: Styles.mainColor, fontWeight: FontWeight.w400,)),
                ),
                const Gap(10),

                // Copyright Informationen
                Text("\u00a9 2023 Janis Wiederkehr", style: Styles.textStyle.copyWith(fontWeight: FontWeight.w400, fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 16 : 20),),
                const Gap(5),

                // Version
                Text("Trumpractice Version v1.0.2", style: Styles.textStyle.copyWith(fontWeight: FontWeight.w400, fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 16 : 20),),

                const Gap(10),
                const Divider(),
                const Gap(10),

                // Alle Übungen aufzeigen (ob Favorit oder nicht)
                Container(
                    margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 20 : 50),
                    alignment: orientation == Orientation.portrait ? Alignment.center : Alignment.center,
                    decoration: BoxDecoration(
                      color: Styles.whiteColor,
                    ),

                    child: Text("Alle Übungen", style: Styles.h2.copyWith(fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 24 : 32),)
                ),
                const Gap(5),
                Column(children: uebungenList.map((singleUebung) => FavoriteSingle(uebung: singleUebung, orientation: orientation, backScreen: 2,)).toList())
              ],
            )
        ),
      ],
    );
  }
}

