
import 'package:countdown/utils/fixed_string.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("initialize fixed string", () {
    FixedString fixedString = FixedString(6, padChar: "0");
    expect(fixedString.value, "000000");

    FixedString fixedString2 = FixedString(6, value: "123456", padChar: "0");
    expect(fixedString2.value, "123456");

    FixedString fixedString3 = FixedString(6, value: "123", padChar: "0");
    expect(fixedString3.value, "000123");
  });

  test("Shift Left", () {
    FixedString fixedString = FixedString(6, value: "123456", padChar: "0");
    fixedString.shiftLeft();
    expect(fixedString.value, "234560");

    FixedString fixedString2 = FixedString(6, value: "123", padChar: "0");
    fixedString2.shiftLeft();
    expect(fixedString2.value, "001230");
  });

  test("Shift Right", () {
    FixedString fixedString = FixedString(6, value: "123456", padChar: "0");
    fixedString.shiftRight();
    expect(fixedString.value, "012345");

    FixedString fixedString2 = FixedString(6, value: "123", padChar: "0");
    fixedString2.shiftRight();
    expect(fixedString2.value, "000012");
  });

  test("shift left with", () {
    FixedString fixedString = FixedString(6, value: "123456", padChar: "0");
    fixedString.shiftLeftWith("7");
    expect(fixedString.value, "234567");
  });

  test("shiftPortionLeft", () {
    FixedString fixedString = FixedString(6, value: "123456", padChar: "0");
    fixedString.shiftPortionLeft(Portion(4, 6), "9");
    expect(fixedString.value, "123469");

    FixedString fixedString2 = FixedString(6, value: "123456", padChar: "0");
    fixedString2.shiftPortionLeft(Portion(0, 2), "9");
    expect(fixedString2.value, "293456");
  });

  test("shiftPortionRight", () {
    FixedString fixedString = FixedString(6, value: "123456", padChar: "0");
    fixedString.shiftPortionRight(Portion(4, 6));
    expect(fixedString.value, "123405");

    FixedString fixedString2 = FixedString(6, value: "123456", padChar: "0");
    fixedString2.shiftPortionRight(Portion(0, 2));
    expect(fixedString2.value, "013456");
  });
}