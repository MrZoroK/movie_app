import 'dart:ui';

enum MonthName {
  January,February,March,April,May,June,
  July,August,September,October,November,December
}
extension DateTimeEx on DateTime {
  String get monthAndYear {
    String strMonth = "";
    MonthName.values.forEach((element) {
      if (element.index + 1 == month) {
        strMonth = element.toString().replaceAll("MonthName.", "");
      }
    });
    return strMonth + " $year";
  }
}

extension RectExt on Rect {
  Rect operator *(double operand) => Rect.fromLTRB(left * operand, top * operand, right * operand, bottom * operand);
}