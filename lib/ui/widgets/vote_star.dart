import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/ui/widgets/progressive_widget.dart';

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
    var inactiveStar = SvgPicture.asset(
      "assets/ic-star-inactive.svg",
      width: size, height: size,
    );
    var activeStar =  SvgPicture.asset(
      "assets/ic-star.svg",
      width: size, height: size
    );
    return Row(
      children: List.generate(5, (idx){
        Widget star;
        if (idx == length - 1 && decimal != 0)
        {
          star = ProgressiveWidget(
            mask: "assets/ic-star-inactive.svg",
            color: Color(0xFFF1CA23),
            size: Size(size, size),
            percent: decimal,
          );
        } else if (idx >= length) {
          star = inactiveStar;
        } else {
          star = activeStar;
        }
        return Padding(
          padding: EdgeInsets.only(right: starAlign),
          child: star,
        );
      })
    );
  }
}