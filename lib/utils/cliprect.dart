
import 'dart:ui';

import 'package:flutter/material.dart';

class ClipHalfRect extends CustomClipper<Rect> {
  final double percentage;
  final bool isUp;


  ClipHalfRect({
    @required this.percentage,
    @required this.isUp,

  });

  @override
  Rect getClip(Size size) {
    Rect rect;
//    if (slideDirection == SlideDirection.Down) {
      if (isUp)

        ///-1.0 -> 0.0
        rect = Rect.fromLTRB(
            0.0, size.height * -percentage, size.width, size.height);
      else

        /// 0 -> 1
        rect = Rect.fromLTRB(
          0.0,
          0.0,
          size.width,
          size.height * (1 - percentage),
        );
//    }

//    else {
//      if (isUp)
//        rect =
//            Rect.fromLTRB(0.0, size.height * (1 + percentage), size.width, 0.0);
//      else
//        rect = Rect.fromLTRB(
//            0.0, size.height * percentage, size.width, size.height);
//    }
    return rect;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}