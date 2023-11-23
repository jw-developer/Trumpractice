import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/device_info.dart';
import '../utils/styles.dart';


class TopBar extends StatelessWidget {
  final String title; // Variabel, damit man den Titel auf jedem Screen individuell anpassen kann
  final Orientation orientation;

  const TopBar({super.key, required this.title, required this.orientation});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // StackWidget, damit der blaue Balken und das Logo übereinander sind
      children: [
        // blauer Balken
        Container(
          color: Styles.mainColor,
          height: 80,
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Trompeten Logo
              Container(
                width: 140,
                height: 140,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/logo.jpeg")),
                ),
              ),
              const Gap(20),
              // Titel der App
              Text(title, style: Styles.h1.copyWith(fontSize: DeviceInfo.width(context) < DeviceInfo.breakpoint1(orientation) ? 32 : 46))
            ],
          ),
        ),
      ],
    );
  }
}