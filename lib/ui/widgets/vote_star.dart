import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/uis.dart';

class VoteStar extends StatelessWidget {
  final double rating;
  final double size;
  final double starAlign;

  VoteStar({
    @required this.rating,
    @required this.size,
    this.starAlign = 0
  });
  
  @override
  Widget build(BuildContext context) {
    int length = rating.floor();
    double decimal = rating - rating.floor();
    if (decimal != 0)
      length++;

    String starPath = "assets/ic-star.svg";
    return Row(
      children: List.generate(5, (idx){
        Widget star;
        if (idx == length - 1 && decimal != 0)
        {
          star = ProgressiveWidget(
            mask: starPath,
            color: Color(0xFFF1CA23),
            size: Size(size, size),
            percent: decimal,
          );
        } else {
          star = SvgPicture.asset(
            starPath,
            width: size, height: size,
            color: idx >= length ? Color(0xFFD2D2D2) : Color(0xFFF1CA23),
          );
        }
        return Padding(
          padding: EdgeInsets.only(right: starAlign),
          child: star,
        );
      })
    );
  }
}