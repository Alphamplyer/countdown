
import 'package:countdown/utils/fixed_string.dart';
import 'package:flutter/material.dart';

enum TimeInputMode {
  all,
  hour,
  minute,
  second,
}

class TimeInputController extends ChangeNotifier {  
  TimeInputMode mode = TimeInputMode.all;
  late StringTime countdownTime;

  TimeInputController({
    int initialTimeInSeconds = 0,
  }) {
    countdownTime = StringTime.fromSeconds(initialTimeInSeconds);
  }

  String get formatedHours => countdownTime.value.substring(countdownTime.hourPortion.start, countdownTime.hourPortion.end);
  String get formatedMinutes => countdownTime.value.substring(countdownTime.minutePortion.start, countdownTime.minutePortion.end);
  String get formatedSeconds => countdownTime.value.substring(countdownTime.secondPortion.start, countdownTime.secondPortion.end);

  int get hours => int.parse(formatedHours);
  int get minutes => int.parse(formatedMinutes);
  int get seconds => int.parse(formatedSeconds);

  int get timeInSeconds => hours * 3600 + minutes * 60 + seconds;

  void setMode(TimeInputMode mode) {
    this.mode = mode;
    notifyListeners();
  }

  void onInput(int value) {
    switch (mode) {
      case TimeInputMode.all:
        onInputInAllMode(value);
        break;
      case TimeInputMode.hour:
        onInputInHourMode(value);
        break;
      case TimeInputMode.minute:
        onInputInMinuteMode(value);
        break;
      case TimeInputMode.second:
        onInputInSecondMode(value);
        break;
      default:
        break;
    }
  }

  void onInputInAllMode(int value) {
    countdownTime.shiftLeftWith(value.toString());
    notifyListeners();
  }

  void onInputInHourMode(int value) {
    countdownTime.shiftHourLeft(value.toString());
    notifyListeners();
  }

  void onInputInMinuteMode(int value) {
    countdownTime.shiftMinuteLeft(value.toString());
    notifyListeners();
  }

  void onInputInSecondMode(int value) {
    countdownTime.shiftSecondLeft(value.toString());
    notifyListeners();
  }

  void onBackspace() {
    switch (mode) {
      case TimeInputMode.all:
        onBackspaceInAllMode();
        break;
      case TimeInputMode.hour:
        onBackspaceInHourMode();
        break;
      case TimeInputMode.minute:
        onBackspaceInMinuteMode();
        break;
      case TimeInputMode.second:
        onBackspaceInSecondMode();
        break;
      default:
        break;
    }
  }

  void onBackspaceInAllMode() {
    countdownTime.shiftRight();
    notifyListeners();
  }

  void onBackspaceInHourMode() {
    countdownTime.shiftHourRight();
    notifyListeners();
  }

  void onBackspaceInMinuteMode() {
    countdownTime.shiftMinuteRight();
    notifyListeners();
  }

  void onBackspaceInSecondMode() {
    countdownTime.shiftSecondRight();
    notifyListeners();
  }
}