import 'package:flutter/material.dart';

extension IntExtension on int? {
  //? means it can be null
  int validate({int value = 0}) {
    return this ?? value;
  }

  Widget get height_space => SizedBox(
        height: this?.toDouble(),
      );

  Widget get width_space => SizedBox(
        width: this?.toDouble(),
      );
}
