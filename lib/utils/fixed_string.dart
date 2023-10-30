
class Portion {
  final int start;
  final int end;

  Portion(this.start, this.end);

  @override
  String toString() {
    return "Portion($start, $end)";
  }
}

class FixedString {
  String _value = "";
  String padChar = "0";  

  FixedString(int length, {String? value, String padChar = "#"}) 
    : assert(length > 0), assert(padChar.length == 1), assert(value == null || value.length <= length)
  {
    _value = (value ?? "").padLeft(length, padChar);
  }

  String get value => _value;

  void shiftLeft() {
    _value = _value.substring(1) + padChar;
  }

  void shiftRight() {      
    _value = padChar + _value.substring(0, _value.length - 1);
  }

  void shiftLeftWith(String value) {
    _value = "${_value.substring(1)}$value";
  }

  FixedString getFixedStringPortion(Portion portion) {
    int portionLength = portion.end - portion.start;
    String portionValue = _value.substring(portion.start, portion.end);

    return FixedString(
      portionLength, 
      value: portionValue, 
      padChar: padChar
    );
  }

  void shiftPortionLeft(Portion portion, String value) {
    FixedString fixedStringPortion = getFixedStringPortion(portion);
    fixedStringPortion.shiftLeftWith(value);
    _value = _value.replaceRange(portion.start, portion.end, fixedStringPortion.value);
  }

  void shiftPortionRight(Portion portion) {
    FixedString fixedStringPortion = getFixedStringPortion(portion);
    fixedStringPortion.shiftRight();
    _value = _value.replaceRange(portion.start, portion.end, fixedStringPortion.value);
  }
}

class StringTime extends FixedString {
  Portion get hourPortion => Portion(0, 2);
  Portion get minutePortion => Portion(2, 4);
  Portion get secondPortion => Portion(4, 6);

  StringTime({String? value}) : super(6, value: value, padChar: "0");

  void shiftHourLeft(String value) {
    shiftPortionLeft(hourPortion, value);
  }

  void shiftHourRight() {
    shiftPortionRight(hourPortion);
  }

  void shiftMinuteLeft(String value) {
    shiftPortionLeft(minutePortion, value);
  }

  void shiftMinuteRight() {
    shiftPortionRight(minutePortion);
  }

  void shiftSecondLeft(String value) {
    shiftPortionLeft(secondPortion, value);
  }

  void shiftSecondRight() {
    shiftPortionRight(secondPortion);
  }

  bool canShiftLeft(FixedString fixedString) {
    return fixedString.value.startsWith(padChar);
  }

  @override
  void shiftLeft() {
    if (canShiftLeft(this)) {
      super.shiftLeftWith(value);
    }
  }

  @override
  void shiftLeftWith(String value) {
    if (canShiftLeft(this)) {
      super.shiftLeftWith(value);
    }
  }

  @override
  void shiftPortionLeft(Portion portion, String value) {
    FixedString fixedStringPortion = getFixedStringPortion(portion);
    if (canShiftLeft(fixedStringPortion)) {
      fixedStringPortion.shiftLeftWith(value);
      _value = _value.replaceRange(portion.start, portion.end, fixedStringPortion.value);
    }
  }

  static StringTime fromSeconds(int initialTimeInSeconds) {
    int hours = initialTimeInSeconds ~/ 3600;
    int minutes = (initialTimeInSeconds % 3600) ~/ 60;
    int seconds = initialTimeInSeconds % 60;

    return StringTime(
      value: "${hours.toString().padLeft(2, '0')}${minutes.toString().padLeft(2, '0')}${seconds.toString().padLeft(2, '0')}"
    );
  }
}