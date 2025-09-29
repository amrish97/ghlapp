import 'package:flutter/cupertino.dart';

extension WidgetExtension on Widget {
  Widget toGesture({required GestureTapCallback onTap}) {
    return GestureDetector(onTap: onTap, child: this);
  }
}

extension ImageExtension on String {
  Widget toImageAsset({
    double? scale,
    double? height,
    double? width,
    BoxFit? fit,
    Color? color,
  }) {
    return Image.asset(
      this,
      scale: scale ?? 3.0,
      height: height,
      width: width,
      color: color,
      fit: fit ?? BoxFit.cover,
    );
  }

  ImageProvider toAssetImageProvider() {
    return AssetImage(this);
  }
}
