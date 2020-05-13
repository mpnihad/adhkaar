import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ShapedWidgetBorder extends RoundedRectangleBorder {
  ShapedWidgetBorder({
    @required this.padding,
    side = BorderSide.none,
    borderRadius = BorderRadius.zero,
  }) : super(side: side, borderRadius: borderRadius);
  final double padding;



  @override
  Path getOuterPath(Rect rect, {  TextDirection textDirection }) {

    return Path()
      ..moveTo(rect.width - 8.0 , rect.top)
      ..lineTo(rect.width - 20.0, rect.top - 16.0)
      ..lineTo(rect.width - 32.0, rect.top)
      ..addRRect(borderRadius
          .resolve(textDirection)
          .toRRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - padding)));
  }
}