import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:trumpractice/uebung.dart';

import '../utils/styles.dart';

class PlayAudio extends StatefulWidget {
  final String audioUrl;
  final dynamic player;

  const PlayAudio({super.key, required this.audioUrl, required this.player});

  @override
  State<PlayAudio> createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  // bool isPlaying = false;
  bool isStopping = false;
  IconData playIcon = Icons.play_arrow;
  @override
  Widget build(BuildContext context) {
    widget.player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          IsPlayingVariable.isPlaying = false;
        });
      }
    });

    return Container(
      // Styling des Button
      height: 40, width: 40, // "quadratische" Grundform mit Seite = 40
      decoration: BoxDecoration(
          color: Styles.secondColor, // Hintergrundfarbe secondColor (grün)
          borderRadius: BorderRadius.circular(100), // abgerundete Ecken, damit es aussieht wie ein Kreis
          border: Border.all(
            color: Styles.secondColor,
            width: 2,
          )),

      child: InkWell(
        // Icon selber
        child: Icon(
          IsPlayingVariable.isPlaying == true
              ? Icons.pause
              : isStopping == true
              ? Icons.stop
              : Icons.play_arrow,
          color: Styles.whiteColor,
        ),

        // Audio pausieren/weiter spielen, wenn man kurz auf den Knopf klickt
        onTap: () async {
          await widget.player.setAsset(widget.audioUrl);

          if (IsPlayingVariable.isPlaying == false) {
            widget.player.play();
            setState(() {
              IsPlayingVariable.isPlaying = true;
            });
          } else {
            widget.player.pause();
            setState(() {
              IsPlayingVariable.isPlaying = false;
            });
          }
        },
      ),
    );
  }
}



