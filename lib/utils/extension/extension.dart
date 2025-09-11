import 'package:flutter/cupertino.dart';

extension WidgetExtension on Widget {
  Widget toGesture({required GestureTapCallback onTap}) {
    return GestureDetector(onTap: onTap, child: this);
  }
}

extension ImageAssetExtension on String {
  Image toImageAsset({
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    double? scale,
  }) {
    return Image.asset(this, fit: fit ?? BoxFit.cover, scale: scale ?? 3.0);
  }
}
