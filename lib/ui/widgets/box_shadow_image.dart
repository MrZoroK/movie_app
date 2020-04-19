import 'package:flutter/material.dart';
import 'dart:ui';
class BoxShadowImage extends StatelessWidget {
  final Widget child;
  final Size size;
  final Color bgColor;
  final double borderRadius;
  final Rect shadowBox;
  final Color shadowColor;
  final double shadowRadius;
  final double shadowBlurRadius;
  
  BoxShadowImage({
    this.child, this.size, this.bgColor, this.borderRadius,
    this.shadowBox, this.shadowColor, this.shadowRadius, this.shadowBlurRadius
  });

  @override
  Widget build(BuildContext context) {
    double reducedShadowWidth = shadowBox.width * 0.9;
    double newShadowLeft = shadowBox.left + (shadowBox.width - reducedShadowWidth) / 2;
    return ClipRect(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: newShadowLeft, top: shadowBox.top),
            width: reducedShadowWidth, height: shadowBox.height,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: shadowBlurRadius, 
                )
              ],
              borderRadius: BorderRadius.circular(shadowRadius)
            ),
          ),
          Container(
            width: size.width, height: size.height,
            child: child,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(borderRadius)
            ),
          )
        ],
      ),
    );
  }
}