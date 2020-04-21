import 'dart:ui';

extension RectExt on Rect {
  Rect operator *(double operand) => Rect.fromLTRB(left * operand, top * operand, right * operand, bottom * operand);
}