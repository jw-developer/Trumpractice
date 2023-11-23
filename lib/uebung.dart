import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:trumpractice/utils/device_info.dart';

import 'package:trumpractice/utils/styles.dart';
import 'package:trumpractice/utils/uebungen_list.dart';
import 'package:trumpractice/widgets/topbar_uebung.dart';
import 'package:trumpractice/widgets/uebung_img.dart';

class Uebung extends StatefulWidget {
  final Map<String, dynamic> uebung;
  final int backScreen;

  const Uebung({super.key, required this.uebung, required this.backScreen});

  @override
  State<Uebung> createState() => _UebungState();
}

class _UebungState extends State<Uebung> {
  int tonart = 0;
  @override
  void initState() {
    tonart = widget.uebung['name'] == "Intervalle" ? 5 : 0;

    if(widget.uebung['name'] == "Dreiklänge") {
      setState(() {
        widget.uebung['artikulationen'] = 1;
        widget.uebung['audio_artikulation'] = 4;
      });
    }

    super.initState();
  }

  int level = 1; // Variable, welche das aktuelle Level der Übung anzeigt (standartmässig = Level 1)

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;


    final player = AudioPlayer();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trompeten Coach Übungen',
      // generelles Styling
      theme: ThemeData(
          primaryColor: Styles.mainColor, // Hauptfarbe
          scaffoldBackgroundColor: Styles.whiteColor, // Hintergrundfarbe
          appBarTheme: AppBarTheme(
            backgroundColor: Styles.mainColor,
            elevation: 0,
            toolbarHeight: 60,
            titleSpacing: 20,
          )),

      home: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          // AppBar der Übung (mit Zurückknopf, Name (+ Tonart und Level))
          appBar: AppBar(
            title: TopBarUebungen(
              uebung: widget.uebung,
              level: level,
              tonart: tonart,
              orientation: orientation,
              backScreen: widget.backScreen,
              player: player,
              ),
          ),

          body: Container(
            padding: EdgeInsets.symmetric(horizontal: DeviceInfo.width(context) < 700 ? 20 : orientation == Orientation.portrait ? 20 : 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: (DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 220 : 400),
                      child: UebungImg(
                        uebung: widget.uebung,
                        tonart: tonart,
                        level: level,
                      ), // Zeigt die Übung als SVG an,
                    ),
                    const Gap(10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: (orientation == Orientation.portrait ? 0 : 0)),
                      child: orientation == Orientation.landscape
                          ?

                      // Tonart- und Levelwechsler im QUERFORMAT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Zeigt Tonartwechsel an
                          if (widget.uebung['art'] != 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // vertieft die Tonart um 1
                                SizedBox(
                                  width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 125 : 200,
                                  child: InkWell(
                                    onTap: () {
                                      player.stop();
                                      setState(() {
                                        IsPlayingVariable.isPlaying = false;
                                        if (tonart == 0) {
                                          if (widget.uebung['art'] == 1) {
                                            tonart = 11; // Tonart springt zu 11, damit ein "Kreis" entsteht
                                          } if (widget.uebung['art'] == 2)  {
                                            tonart = 11;
                                          } if (widget.uebung['art'] == 3)  {
                                            tonart = 6;
                                          } if (widget.uebung['art'] == 4) {
                                            tonart = 24;
                                          }
                                        } else {
                                          tonart--; // tonart-- ist das gleiche wie tonart = tonart - 1
                                        }
                                      });
                                    },

                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        const Icon(Icons
                                            .arrow_back_ios), // Pfeil nach links symbolisiert, dass die Tonart vertieft wird
                                        Text(
                                          widget.uebung["art"] == 1
                                              ? quintenZirkel[(tonart != 0 ? tonart - 1 : 11) % quintenZirkel.length]
                                              : widget.uebung["art"] == 2
                                              ? chromatisch[(tonart != 0 ? tonart - 1 : 11) % chromatisch.length]
                                              : widget.uebung['art'] == 3
                                              ? art3[(tonart != 0 ? tonart -1 : 6) & art3.length]

                                              : art4[(tonart != 0 ? tonart - 1 : 24) % art4.length],

                                          style: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? Styles.h2 : Styles.h1.copyWith(fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Gap(10),

                                // Zufällige Tonart Knopf
                                Container(
                                  // Styling des Button
                                    height: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 30 : 50,
                                    width:
                                    DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 30 : 50, // "quadratische" Grundform mit Seite = 40
                                    decoration: BoxDecoration(
                                        color: Styles
                                            .secondColor, // Hintergrundfarbe secondColor (grün)
                                        borderRadius: BorderRadius.circular(
                                            (
                                                100)), // abgerundete Ecken, damit es aussieht wie ein Kreis
                                        border: Border.all(
                                          color: Styles.secondColor,
                                          width: 2,
                                        )),
                                    child: InkWell(
                                      // Icon selber
                                      child: Icon(
                                        Icons.autorenew_rounded,
                                        color: Styles.whiteColor,
                                      ),

                                      onTap: () {
                                        player.stop();
                                        setState(() {
                                          IsPlayingVariable.isPlaying = false;
                                          if (widget.uebung["art"] == 3) {
                                            tonart = Random().nextInt(7);
                                          } if (widget.uebung['art'] == 4) {
                                            tonart = Random().nextInt(25);
                                          } else {
                                            tonart = Random().nextInt(12);
                                          }

                                        });
                                      },
                                    )),

                                const Gap(10),

                                // erhöht die Tonart um 1
                                SizedBox(
                                  width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 125 : 200,
                                  child: InkWell(
                                    onTap: () {
                                      player.stop();
                                      setState(() {
                                        IsPlayingVariable.isPlaying = false;
                                        if (widget.uebung["art"] == 1 ? tonart ==  11 : widget.uebung["art"] == 2 ? tonart ==  11 : widget.uebung['art'] == 3 ? tonart == 6 : tonart == 24 ) {
                                          tonart =
                                          0; // Tonart springt zu 0, damit ein Kreis entsteht
                                        } else {
                                          tonart++; // tonart++ ist das gleiche wie tonart = tonart + 1
                                        }
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.uebung["art"] == 1
                                              ? quintenZirkel[(tonart != 11 ? tonart + 1 : 0) % quintenZirkel.length]
                                              : widget.uebung["art"] == 2
                                              ? chromatisch[(tonart != 11 ? tonart + 1 : 0) % chromatisch.length]
                                              : widget.uebung['art'] == 3
                                              ? art3[(tonart != 6 ? tonart + 1 : 0) & art3.length]

                                              : art4[(tonart != 24 ? tonart + 1 : 0) % art4.length],

                                          style: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? Styles.h2 : Styles.h1.copyWith(fontWeight: FontWeight.w500),
                                        ),
                                        const Icon(Icons
                                            .arrow_forward_ios), // Pfeil nach rechts symbolisiert, dass die Tonart erhöht wird
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          // Varianten
                          if(DeviceInfo.breakpoint1(orientation) > 700 && widget.uebung['artikulationsvarianten'] == true)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const RotatedBox(
                                quarterTurns: 3,
                                child: Text(
                                  "Varianten",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              const Gap(5),

                              widget.uebung['artikulationen'] == 1 ?
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 1 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation1.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                      ),
                                      const Gap(10),
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 2 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation2.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                      ),
                                    ],
                                  ),

                                  const Gap((5)),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 3 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation3.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                      ),
                                      const Gap(10),
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 4 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation4.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                              : widget.uebung['artikulationen'] == 2 ?
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 1 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation5.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                      ),
                                      const Gap(10),
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 2 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation6.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                      ),
                                    ],
                                  ),

                                  const Gap((5)),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 3 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation7.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                      ),
                                      const Gap(10),
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 4 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation8.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                              : widget.uebung['artikulationen'] == 3 ?
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 1 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation9.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                      ),
                                      const Gap(10),
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 2 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation10.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                      ),
                                    ],
                                  ),

                                  const Gap((5)),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 3 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation11.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                      ),
                                      const Gap(10),
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 4 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset("assets/images/artikulation12.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                              : widget.uebung['artikulationen'] == 4 ?
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 1 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: SvgPicture.asset("assets/images/artikulation13.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                      ),
                                      const Gap(10),
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 2 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: SvgPicture.asset("assets/images/artikulation14.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                      ),
                                    ],
                                  ),
                                ],
                          )
                              // Varianten bei artikulationen == 5
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 1 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: SvgPicture.asset("assets/images/artikulation15.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                      ),
                                      const Gap(10),
                                      Container(
                                        color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 2 ? 0.25 : 0),
                                        padding: const EdgeInsets.all(2),
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: SvgPicture.asset("assets/images/artikulation16.svg",
                                            width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ]
                          ),

                          // Zeigt Levelwechsel an
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // vertieft das Level um 1
                              if (level != 1)
                                InkWell(
                                  onTap: () {
                                    player.stop();
                                    setState(() {
                                      IsPlayingVariable.isPlaying = false;
                                      level--; // ernierdrigt das Level um 1

                                      if(widget.uebung['name'] == "Dreiklänge" && level == 2) {
                                        setState(() {
                                          widget.uebung['artikulationen'] = 2;
                                          widget.uebung['audio_artikulation'] = 2;
                                        });
                                      } if(widget.uebung['name'] == "Dreiklänge" && level == 1) {
                                        setState(() {
                                          widget.uebung['artikulationen'] = 1;
                                          widget.uebung['audio_artikulation'] = 4;
                                        });
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons
                                          .arrow_back_ios), // Pfeil nach links symbolisiert, dass das Level erniedrigt wird
                                      Text(
                                        "Level ${level - 1}",
                                        style: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? Styles.h2 : Styles.h1.copyWith(fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),

                              if (level > 1 &&
                                  level != widget.uebung['level'])
                                const Gap(10),

                              // erhöht das Level um 1
                              if (level != widget.uebung['level'])
                                InkWell(
                                  onTap: () {
                                    player.stop();
                                    setState(() {
                                      IsPlayingVariable.isPlaying = false;
                                      level++; // erhöht das Level um 1

                                      if(widget.uebung['name'] == "Dreiklänge" && level == 2) {
                                        setState(() {
                                          widget.uebung['artikulationen'] = 2;
                                          widget.uebung['audio_artikulation'] = 2;
                                        });
                                      } if(widget.uebung['name'] == "Dreiklänge" && level == 1) {
                                        setState(() {
                                          widget.uebung['artikulationen'] = 1;
                                          widget.uebung['audio_artikulation'] = 4;
                                        });
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Level ${level + 1}",
                                        style: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? Styles.h2 : Styles.h1.copyWith(fontWeight: FontWeight.w500),
                                      ),
                                      const Icon(Icons
                                          .arrow_forward_ios), // Pfeil nach rechts symbolisiert, dass das Level erhöht wird
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      )
                          :

                      // Tonart- und Levelwechsler im HOCHFORMAT
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Zeigt Tonartwechsel an
                          if (widget.uebung['art'] != 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // vertieft die Tonart um 1
                                SizedBox(
                                  width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 125 : 200,
                                  child: InkWell(
                                    onTap: () {
                                      player.stop();
                                      setState(() {
                                        IsPlayingVariable.isPlaying = false;
                                        if (tonart == 0) {
                                          if (widget.uebung['art'] == 1) {
                                            tonart = 11; // Tonart springt zu 11, damit ein "Kreis" entsteht
                                          } if (widget.uebung['art'] == 2)  {
                                            tonart = 11;
                                          } if (widget.uebung['art'] == 3)  {
                                            tonart = 6;
                                          } if (widget.uebung['art'] == 4) {
                                            tonart = 24;
                                          }
                                        } else {
                                          tonart--; // tonart-- ist das gleiche wie tonart = tonart - 1
                                        }
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        const Icon(Icons
                                            .arrow_back_ios), // Pfeil nach links symbolisiert, dass die Tonart vertieft wird
                                        Text(
                                          widget.uebung["art"] == 1
                                              ? quintenZirkel[(tonart != 0 ? tonart - 1 : 11) % quintenZirkel.length]
                                              : widget.uebung["art"] == 2
                                              ? chromatisch[(tonart != 0 ? tonart - 1 : 11) % chromatisch.length]
                                              : widget.uebung['art'] == 3
                                              ? art3[(tonart != 0 ? tonart -1 : 6) & art3.length]

                                              : art4[(tonart != 0 ? tonart - 1 : 24) % art4.length],

                                          style: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? Styles.h2 : Styles.h1.copyWith(fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Gap(10),

                                // Zufällige Tonart Knopf
                                Container(
                                  // Styling des Button
                                    height: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 30 : 50,
                                    width:
                                    DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 30 : 50, // "quadratische" Grundform mit Seite = 40
                                    decoration: BoxDecoration(
                                        color: Styles
                                            .secondColor, // Hintergrundfarbe secondColor (grün)
                                        borderRadius: BorderRadius.circular(
                                            (
                                                100)), // abgerundete Ecken, damit es aussieht wie ein Kreis
                                        border: Border.all(
                                          color: Styles.secondColor,
                                          width: 2,
                                        )),
                                    child: InkWell(
                                      // Icon selber
                                      child: Icon(
                                        Icons.autorenew_rounded,
                                        color: Styles.whiteColor,
                                      ),

                                      onTap: () {
                                        player.stop();
                                        setState(() {
                                          IsPlayingVariable.isPlaying = false;
                                          if (widget.uebung["art"] == 3) {
                                            tonart = Random().nextInt(7);
                                          } if (widget.uebung['art'] == 4) {
                                            tonart = Random().nextInt(25);
                                          } else {
                                            tonart = Random().nextInt(12);
                                          }

                                        });
                                      },
                                    )),

                                const Gap(10),

                                // erhöht die Tonart um 1
                                SizedBox(
                                  width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 125 : 200,
                                  child: InkWell(
                                    onTap: () {
                                      player.stop();
                                      setState(() {
                                        IsPlayingVariable.isPlaying = false;
                                        if (widget.uebung["art"] == 1 ? tonart ==  11 : widget.uebung["art"] == 2 ? tonart ==  11 : widget.uebung['art'] == 3 ? tonart == 6 : tonart == 24 ) {
                                          tonart =
                                          0; // Tonart springt zu 0, damit ein Kreis entsteht
                                        } else {
                                          tonart++; // tonart++ ist das gleiche wie tonart = tonart + 1
                                        }
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.uebung["art"] == 1
                                              ? quintenZirkel[(tonart != 11 ? tonart + 1 : 0) % quintenZirkel.length]
                                              : widget.uebung["art"] == 2
                                              ? chromatisch[(tonart != 11 ? tonart + 1 : 0) % chromatisch.length]
                                              : widget.uebung['art'] == 3
                                              ? art3[(tonart != 6 ? tonart + 1 : 0) & art3.length]

                                              : art4[(tonart != 24 ? tonart + 1 : 0) % art4.length],

                                          style: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? Styles.h2 : Styles.h1.copyWith(fontWeight: FontWeight.w500),
                                        ),
                                        const Icon(Icons
                                            .arrow_forward_ios), // Pfeil nach rechts symbolisiert, dass die Tonart erhöht wird
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          const Gap(15),
                          // Zeigt Levelwechsel an
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // vertieft das Level um 1
                              if (level != 1)
                                InkWell(
                                  onTap: () {
                                    player.stop();
                                    setState(() {
                                      IsPlayingVariable.isPlaying = false;
                                      level--; // ernierdrigt das Level um 1

                                      if(widget.uebung['name'] == "Dreiklänge" && level == 2) {
                                        setState(() {
                                          widget.uebung['artikulationen'] = 2;
                                          widget.uebung['audio_artikulation'] = 2;
                                        });
                                      } if(widget.uebung['name'] == "Dreiklänge" && level == 1) {
                                        setState(() {
                                          widget.uebung['artikulationen'] = 1;
                                          widget.uebung['audio_artikulation'] = 4;
                                        });
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons
                                          .arrow_back_ios), // Pfeil nach links symbolisiert, dass das Level erniedrigt wird
                                      Text(
                                        "Level ${level - 1}",
                                        style: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? Styles.h2 : Styles.h1.copyWith(fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),

                              if (level > 1) const Gap(40),

                              // erhöht das Level um 1
                              if (level != widget.uebung['level'])
                                InkWell(
                                  onTap: () {
                                    player.stop();
                                    setState(() {
                                      IsPlayingVariable.isPlaying = false;
                                      level++; // erhöht das Level um 1

                                      if(widget.uebung['name'] == "Dreiklänge" && level == 2) {
                                        setState(() {
                                          widget.uebung['artikulationen'] = 2;
                                          widget.uebung['audio_artikulation'] = 2;
                                        });
                                      } if(widget.uebung['name'] == "Dreiklänge" && level == 1) {
                                        setState(() {
                                          widget.uebung['artikulationen'] = 1;
                                          widget.uebung['audio_artikulation'] = 4;
                                        });
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Level ${level + 1}",
                                        style: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? Styles.h2 : Styles.h1.copyWith(fontWeight: FontWeight.w500),
                                      ),
                                      const Icon(Icons
                                          .arrow_forward_ios), // Pfeil nach rechts symbolisiert, dass das Level erhöht wird
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Metronom, PlayAudio, Tonart- und Levelwechsel, wenn das Handy im Hochformat ist
                if (orientation == Orientation.portrait)
                  const Gap(15),

                if (orientation == Orientation.portrait)
                // Varianten
                  if(widget.uebung['artikulationsvarianten'] == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            "Varianten",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const Gap(5),

                        widget.uebung['artikulationen'] == 1 ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 1 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation1.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                ),
                                const Gap(10),
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 2 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation2.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                ),
                              ],
                            ),

                            const Gap((5)),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 3 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation3.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                ),
                                const Gap(10),
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 4 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation4.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                ),
                              ],
                            ),
                          ],
                        )
                            : widget.uebung['artikulationen'] == 2 ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 1 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation5.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                ),
                                const Gap(10),
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 2 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation6.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                ),
                              ],
                            ),

                            const Gap((5)),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 3 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation7.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                ),
                                const Gap(10),
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 4 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation8.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                ),
                              ],
                            ),
                          ],
                        )
                            : widget.uebung['artikulationen'] == 3 ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 1 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation9.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                ),
                                const Gap(10),
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 2 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation10.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                ),
                              ],
                            ),

                            const Gap((5)),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 3 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation11.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                ),
                                const Gap(10),
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 4 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset("assets/images/artikulation12.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                ),
                              ],
                            ),
                          ],
                        )
                            : widget.uebung['artikulationen'] == 4 ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 1 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: SvgPicture.asset("assets/images/artikulation13.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                ),
                                const Gap(10),
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 2 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: SvgPicture.asset("assets/images/artikulation14.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 60 : 100),
                                ),
                              ],
                            ),
                          ],
                        )
                        // Varianten bei artikulationen == 5
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 1 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: SvgPicture.asset("assets/images/artikulation15.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                ),
                                const Gap(10),
                                Container(
                                  color: Styles.secondColor.withOpacity(widget.uebung['audio_artikulation'] == 2 ? 0.25 : 0),
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: SvgPicture.asset("assets/images/artikulation16.svg",
                                      width: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 80 : 120),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// "globale" Variable, ob PlayAudio gerade spielt oder nicht
class IsPlayingVariable {
  static bool isPlaying = false;
}
