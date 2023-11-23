import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceInfo {
  static width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static breakpoint1(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return 500;
    } if (orientation == Orientation.landscape) {
      return 1000;
    }
  }
}