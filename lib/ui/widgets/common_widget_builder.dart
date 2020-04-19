import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonWidgetBuilder {
  static Widget loadNetworkImage(url, {width: 100.0, height: 100.0, EdgeInsets padding: const EdgeInsets.all(0), linearProcess: true, roundRadius = 0.0 }) {

    Widget img = CachedNetworkImage(
      placeholder: (context, url) {
        return Shimmer.fromColors(
          child: Container(
            color: Colors.grey[300],
            width: width, height: height,
          ),
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[50],
        );
      },
      imageUrl: url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) {
        return Center(
          child: Icon(
            Icons.warning
          ),
        );
      },
    );

    Widget res;
    if (roundRadius != 0.0) {
      res = ClipRRect(
        child: img, clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(roundRadius)
      );
    } else {
      res = img;
    }

    return Container(
      padding: padding,
      child: Center(
        child: res,
      )
    );
  }
}