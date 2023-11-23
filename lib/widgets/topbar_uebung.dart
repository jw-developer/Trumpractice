import 'package:flutter/material.dart';
import 'package:trumpractice/uebung.dart';
import 'package:trumpractice/widgets/playaudio.dart';
import '../main.dart';


import '../favoriten.dart';
import '../utils/device_info.dart';
import '../utils/styles.dart';
import '../utils/uebungen_list.dart';
import 'favorite_icon.dart';

class TopBarUebungen extends StatelessWidget {
  final Map<String, dynamic> uebung;
  final int level;
  final int tonart;
  final Orientation orientation;
  final int backScreen;
  final dynamic player;

  const TopBarUebungen({
    Key? key,
    required this.uebung,
    required this.level,
    required this.tonart,
    required this.orientation,
    required this.backScreen,
    required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Styles.mainColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              FittedBox(
                child: IconButton(
                  onPressed: () {
                    getFavorits();

                    player.stop();
                    IsPlayingVariable.isPlaying = false;


                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => MyApp(backScreen: backScreen,),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(-1.0, 0.0);
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
                  icon: Icon(Icons.arrow_back_ios, color: Styles.whiteColor),
                ),
              ),
              FittedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      uebung["name"],
                      style: TextStyle(color: Colors.white, fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 20 : 26),
                    ),
                    Row(
                      children: [
                        if (uebung['art'] == 1)
                          Text(
                            quintenZirkel[tonart],
                            style: TextStyle(color: Colors.white, fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 14 : 18, fontWeight: FontWeight.w400),
                          ),

                        if (uebung['art'] == 2)
                          Text(
                            chromatisch[tonart],
                            style: TextStyle(color: Colors.white, fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 14 : 18, fontWeight: FontWeight.w400),
                          ),

                        if (uebung['art'] == 3)
                          Text(
                            art3[tonart],
                            style: TextStyle(color: Colors.white, fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 14 : 18, fontWeight: FontWeight.w400),
                          ),

                        if (uebung['art'] == 4)
                          Text(
                            art4[tonart],
                            style: TextStyle(color: Colors.white, fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 14 : 18, fontWeight: FontWeight.w400),
                          ),

                        if (uebung['art'] != 0 && uebung['level'] > 1)
                          Text(
                            ", ",
                            style: TextStyle(color: Colors.white, fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 14 : 18, fontWeight: FontWeight.w400),
                          ),

                        if (uebung['level'] > 1)
                          Text(
                            "Level $level",
                            style: TextStyle(color: Colors.white, fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 14 : 18, fontWeight: FontWeight.w400),
                          ),
                      ],
                    )

                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              FavoriteIcon(
                uebung: uebung,
                color: Styles.whiteColor,
              ),
              if(uebung["topbar_func"] == true)
                uebung['level'] != 1 ? PlayAudio(audioUrl: "assets/${uebung["uebungUrl"]}audio$level.m4a", player: player,) :
                PlayAudio(audioUrl: "assets/${uebung["uebungUrl"]}audio.m4a", player: player,)
            ],
          )

        ],
      ),
    );
  }
}

