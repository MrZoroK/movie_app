import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';

enum SectionStyle {
  TRENDING,
  HOME,
  DETAIL
}
extension SectionStyleExt on SectionStyle {
  Color get titleBgColor {
    return this == SectionStyle.DETAIL ? const Color(0xFFF2F2F2) : Colors.transparent;
  }
  Color get textColor {
    return this == SectionStyle.DETAIL ? const Color(0xFF4A4A4A) : TITLE_COLOR;
  }
  double get textSize {
    return this == SectionStyle.TRENDING ? 20 : 18;
  }
  double get titleMargin {
    if (this == SectionStyle.TRENDING) {
      return 18;
    } else if (this == SectionStyle.HOME) {
      return 14;
    } else {
      return 15;
    }
  }

  EdgeInsetsGeometry get tilePadding {
    var padding = EdgeInsets.only(left: ALL_LEFT_PADDING.left, right: 16);
    if (this == SectionStyle.DETAIL) {
      padding = padding.add(EdgeInsets.only(top: 11, bottom: 11));
    }
    return padding;
  }
}

class SectionWidget extends StatelessWidget {
  final String text;
  final SectionStyle sectionStyle;
  final Widget list;
  final VoidCallback onPressed;

  SectionWidget({
    @required this.text,
    @required this.sectionStyle,
    @required this.list,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    Widget arrow = Container();
    if (onPressed != null) {
      arrow = InkWell(
        child: SvgPicture.asset (
          "assets/ic-arrow-blue.svg",
          width: 22, height: 22,
        ),
        onTap: onPressed,
      );
    }

    Widget title = Container(
      padding: sectionStyle.tilePadding,
      margin: EdgeInsets.only(bottom: sectionStyle.titleMargin),
      color: sectionStyle.titleBgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: sectionStyle.textSize, color: sectionStyle.textColor
            ),
          ),
          arrow
        ],
      ),
    );

    return Column(
      children: [
        title,
        Padding(
          padding: ALL_LEFT_PADDING,
          child: list,
        )
      ],
    );
  }
}