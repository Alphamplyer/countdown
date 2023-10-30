
import 'dart:async';

import 'package:countdown/domain/countdown_entity.dart';
import 'package:countdown/domain/countdown_state.dart';
import 'package:countdown/widgets/time_input_form.dart';
import 'package:flutter/material.dart';

class _HourMinuteSecondControl extends StatelessWidget {
  const _HourMinuteSecondControl({
    required this.text,
    required this.label,
    required this.onTap,
  });

  final String text;
  final String label;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 80,
          width: 96,
          child: Material(
            color: theme.colorScheme.surfaceVariant,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: onTap,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 57,
                    fontWeight: FontWeight.normal,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -16,
          left: 0,
          right: 0,
          child: Text(
            label, 
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium
          ),
        ),
      ],
    );
  }
}

class _TimeSelectorSeparator extends StatelessWidget {
  const _TimeSelectorSeparator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Text(
        ':',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}

class Countdown extends StatefulWidget {
  final CountdownEntity countdown;

  const Countdown({super.key, required this.countdown});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late ValueNotifier<int> _countdownTimerNotifier;
  late ValueNotifier<CountdownState> _countdownStateNotifier;
  late ValueNotifier<bool> _editNotifier;
  Timer? timer;

  @override
  void initState() {
    _countdownTimerNotifier = ValueNotifier(widget.countdown.initialTimeInSeconds);
    _countdownStateNotifier = ValueNotifier(widget.countdown.state);
    _editNotifier = ValueNotifier(false);
    super.initState();
  }

  void onClickStart() {
    widget.countdown.start();
    _countdownTimerNotifier.value = widget.countdown.currentTimeInSeconds;
    _countdownStateNotifier.value = widget.countdown.state;

    timer = Timer.periodic(
      const Duration(seconds: 1), 
      (_) { 
        widget.countdown.tick();
        _countdownTimerNotifier.value = widget.countdown.currentTimeInSeconds;
        _countdownStateNotifier.value = widget.countdown.state;

        if (widget.countdown.state == CountdownState.finished) {
          timer?.cancel();
        }
      }
    );
  }

  void onClickStop() {
    timer?.cancel();
    widget.countdown.stop();
    _countdownStateNotifier.value = widget.countdown.state;
  }

  void onClickReset() {
    widget.countdown.reset();
    _countdownTimerNotifier.value = widget.countdown.currentTimeInSeconds;
    _countdownStateNotifier.value = widget.countdown.state;
  }

  void onTapOnCountdown() {
    if (widget.countdown.state != CountdownState.initial) {
      return;
    }
    toggleEdit();
  }

  void toggleEdit() {
    _editNotifier.value = !_editNotifier.value;
  }

  Widget buildTimeInputForm() {
    return TimeInputForm(
      initialTimeInSeconds: widget.countdown.initialTimeInSeconds,
      onConfirm: (int seconds) {
        widget.countdown.setInitialTime(seconds);
        toggleEdit();
      },
      onCancel: toggleEdit,
    );
  }

  Widget buildCountdown() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _countdownTimerNotifier,
          builder: (context, countdownTickUpdate, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _HourMinuteSecondControl(
                  text: widget.countdown.formatedHours,
                  label: 'Hours',
                  onTap: onTapOnCountdown,
                ),
                const _TimeSelectorSeparator(),
                _HourMinuteSecondControl(
                  text: widget.countdown.formatedMinutes,
                  label: 'Minutes',
                  onTap: onTapOnCountdown,
                ),
                const _TimeSelectorSeparator(),
                _HourMinuteSecondControl(
                  text: widget.countdown.formatedSeconds,
                  label: 'Seconds',
                  onTap: onTapOnCountdown,
                ),
              ],
            );
          }
        ),
        const SizedBox(height: 62),
        ValueListenableBuilder<CountdownState>(
          valueListenable: _countdownStateNotifier,
          builder: (_, value, __) {
            switch (value) {
              case CountdownState.initial:
                return SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: onClickStart,
                    child: const Text('Start'),
                  ),
                );
              case CountdownState.running:
                return SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
                    onPressed: onClickStop,
                    child: const Text('Stop'),
                  ),
                );
              case CountdownState.paused:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.onSecondary,
                        ),
                        onPressed: onClickReset,
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 200,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: onClickStart,
                        child: const Text('Resume'),
                      ),
                    ),
                  ],
                );
              case CountdownState.finished:
                return SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    ),
                    onPressed: onClickReset,
                    child: const Text('Reset'),
                  ),
                );
            }
          },
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _editNotifier,
      builder: (context, isEditing, child) {
        if (isEditing) {
          return buildTimeInputForm();
        } else {
          return buildCountdown();
        }
      }
    );
  }
}