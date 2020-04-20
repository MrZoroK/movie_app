import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_svg/flutter_svg.dart';

class ProgressiveWidget extends StatelessWidget {
  final String mask;
  final Color color;
  final Size size;
  final double percent;
  ProgressiveWidget({
    @required this.mask,
    @required this.color,
    @required this.size,
    @required this.percent});

  @override
  Widget build(BuildContext context) {
    if (mask.endsWith(".svg")) {
      Completer<PictureInfo> completer = Completer<PictureInfo>();
      var svgPicture = SvgPicture.asset(mask);
      svgPicture.pictureProvider.resolve(
        PictureConfiguration()
      ).addListener((picInfo, _) {
        return completer.complete(picInfo);
      });
      
      return FutureBuilder<PictureInfo>(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<PictureInfo> snapshot){
          if (snapshot.hasData && snapshot.data != null) {
            PictureInfo mask = snapshot.data;
            return SizedBox(
              width: size.width, height: size.height,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox.fromSize(
                  size: mask.size,
                  child: CustomPaint(
                    painter: _ProgressivePainter(null, mask, color, percent, 0.0),
                    size: size,
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      );
    } else {
      Completer<ui.Image> completer = Completer<ui.Image>();
      AssetImage(mask).resolve(
        ImageConfiguration(devicePixelRatio: ui.window.devicePixelRatio)
      ).addListener(ImageStreamListener((ImageInfo imgInfo, bool _) => completer.complete(imgInfo.image)));

      return FutureBuilder<ui.Image>(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot){
          if (snapshot.hasData && snapshot.data != null) {
            ui.Image mask = snapshot.data;
            return CustomPaint(
              painter: _ProgressivePainter(mask, null, color, percent, 0.0),
              size: size,
            );
          }
          return Container();
        },
      );
    }
  }
}


class _ProgressivePainter extends CustomPainter {
  final ui.Image imgMask;
  final PictureInfo picMask;
  final Color color;
  final double _percent;
  final double _deltaLT;
  @override _ProgressivePainter(this.imgMask, this.picMask, this.color, this._percent, this._deltaLT);
  @override

  void paint(Canvas canvas, Size sz) {
    Size size;
    if (imgMask != null) {
      size = sz;
    } else if (picMask != null) {
      size = picMask.size;
    }

    Paint paint = new Paint()
                  ..color = color;
    var maskRect = Rect.fromLTRB(0, 0, sz.width, sz.height);
    
    //Mask
    canvas.saveLayer(maskRect, paint);
    if (imgMask != null) {
      Size maskInputSize = Size(imgMask.width.toDouble(), imgMask.height.toDouble());
      final FittedSizes maskFittedSizes =
          applyBoxFit(BoxFit.cover, maskInputSize, size);
      final Size maskSourceSize = maskFittedSizes.source;

      final Rect maskSourceRect = Alignment.center
          .inscribe(maskSourceSize, Offset.zero & maskInputSize);

      canvas.drawImageRect(imgMask, maskSourceRect, maskRect, paint);
    } else if (picMask != null) {
      canvas.drawPicture(picMask.picture);
    }
    

    //Progression
    var delta = size.width * _deltaLT;
    var rect = Rect.fromLTRB(delta, delta, size.width * _percent, size.height - delta);
    canvas.drawRect(rect, paint..blendMode = BlendMode.srcIn);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}