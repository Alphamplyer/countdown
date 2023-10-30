
import 'package:countdown/domain/countdown_manager.dart';
import 'package:countdown/domain/countdown_state.dart';
import 'package:countdown/services/windows_notification_service.dart';

class CountdownEntity {
  final String id;
  CountdownState state = CountdownState.initial;
  int _currentTimeInSeconds = 0;
  int _initialTimeInSeconds;

  int get initialTimeInSeconds => _initialTimeInSeconds;
  int get currentTimeInSeconds => _currentTimeInSeconds;

  int get hours => _currentTimeInSeconds ~/ 3600;
  int get minutes => (_currentTimeInSeconds % 3600) ~/ 60;
  int get seconds => _currentTimeInSeconds % 60;

  String get formatedHours => hours.toString().padLeft(2, '0');
  String get formatedMinutes => minutes.toString().padLeft(2, '0');
  String get formatedSeconds => seconds.toString().padLeft(2, '0');

  CountdownEntity({
    required this.id,
    int initialTimeInSeconds = 0,
    int? currentTimeInSeconds,
  }) : _initialTimeInSeconds = initialTimeInSeconds 
  {
    _currentTimeInSeconds = currentTimeInSeconds ?? _initialTimeInSeconds;
  }

  Future<void> setInitialTime(int value) async {
    _initialTimeInSeconds = value;
    _currentTimeInSeconds = value;
    CountdownManager.saveCountdown(this);
  }

  void start() {
    state = CountdownState.running;
  }

  void stop() {
    state = CountdownState.paused;
  }

  void reset() {
    state = CountdownState.initial;
    _currentTimeInSeconds = _initialTimeInSeconds;
  }

  void tick() {
    _currentTimeInSeconds = _currentTimeInSeconds - 1;
    
    if (_currentTimeInSeconds <= 0) {
      _currentTimeInSeconds = 0;
      state = CountdownState.finished;
      WindowsNotificationService.notifyEndOfCountdown();
    }
  }
}