import 'package:flutter/material.dart';
import 'dart:ui';

import 'common_widget_builder.dart';

class BoxShadowImage extends StatelessWidget {
  final String imgUrl;
  final Size size;
  final double borderRadius;
  final Rect shadowRect;
  final double shadowBlurRadius;
  final double shadowBorderRadius;
  final Widget child;
  
  BoxShadowImage({
    this.imgUrl, this.size, this.borderRadius,
    this.shadowRect, this.shadowBlurRadius, this.shadowBorderRadius,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    
    return ClipRect(
      child: Stack(
        children: <Widget>[
          _shadowBackground(),
          _image()
        ],
      ),
    );
  }

  Widget _shadowBackground() {
    double reducedShadowWidth = shadowRect.width * 0.9;
    double newShadowLeft = shadowRect.left + (shadowRect.width - reducedShadowWidth) / 2;

    return Container(
      margin: EdgeInsets.only(left: newShadowLeft, top: shadowRect.top),
      width: reducedShadowWidth, height: shadowRect.height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4A4A4A).withOpacity(0.7),
            blurRadius: shadowBlurRadius, 
          )
        ],
        borderRadius: BorderRadius.circular(shadowBorderRadius)
      ),
    );
  }

  Widget _image() {
    Widget img = Container();
    if (imgUrl != null) {
      img = CommonWidgetBuilder.loadNetworkImage(        
        imgUrl,
        width: size.width, height: size.height,
        roundRadius: borderRadius,
      );
    } else if (child != null) {
      img = child;
    }

    return Container(
      width: size.width, height: size.height,
      child: img,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius)
      ),
    );
  }
}