
import 'package:countdown/widgets/time_input_controller.dart';
import 'package:flutter/material.dart';

class _HourMinuteSecondControl extends StatelessWidget {
  const _HourMinuteSecondControl({
    required this.text,
    required this.label,
    required this.onTap,
    required this.onDoubleTap,
    required this.isSelected,
  });

  final String text;
  final String label;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final bool isSelected;

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
            color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceVariant,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: onTap,
              onDoubleTap: onDoubleTap,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 57,
                    fontWeight: FontWeight.normal,
                    color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
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


class TimeInputForm extends StatefulWidget {
  final int initialTimeInSeconds;
  final Function(int)? onConfirm;
  final VoidCallback? onCancel;

  const TimeInputForm({super.key, required this.initialTimeInSeconds, this.onConfirm, this.onCancel});

  @override
  State<TimeInputForm> createState() => _TimeInputFormState();
}

class _TimeInputFormState extends State<TimeInputForm> {
  late TimeInputController controller;

  @override
  void initState() {
    controller = TimeInputController(initialTimeInSeconds: widget.initialTimeInSeconds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _HourMinuteSecondControl(
                  text: controller.formatedHours,
                  label: 'Hours',
                  isSelected: controller.mode == TimeInputMode.hour,
                  onTap: () {
                    controller.setMode(TimeInputMode.hour);
                  },
                  onDoubleTap: () {},
                ),
                const _TimeSelectorSeparator(),
                _HourMinuteSecondControl(
                  text: controller.formatedMinutes,
                  label: 'Minutes',
                  isSelected: controller.mode == TimeInputMode.minute,
                  onTap: () {
                    controller.setMode(TimeInputMode.minute);
                  },
                  onDoubleTap: () {},
                ),
                const _TimeSelectorSeparator(),
                _HourMinuteSecondControl(
                  text: controller.formatedSeconds, 
                  label: 'Seconds',
                  isSelected: controller.mode == TimeInputMode.second,
                  onTap: () {
                    controller.setMode(TimeInputMode.second);
                  },
                  onDoubleTap: () {},
                ),
              ],
            );
          }
        ),
        const SizedBox(height: 62),
        Flexible(
          child: SizedBox(
            width: 300,
            child: GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              children: [
                TextButton(onPressed: () => controller.onInput(1), child: const Text("1", style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal))),
                TextButton(onPressed: () => controller.onInput(2), child: const Text("2", style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal))),
                TextButton(onPressed: () => controller.onInput(3), child: const Text("3", style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal))),
                TextButton(onPressed: () => controller.onInput(4), child: const Text("4", style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal))),
                TextButton(onPressed: () => controller.onInput(5), child: const Text("5", style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal))),
                TextButton(onPressed: () => controller.onInput(6), child: const Text("6", style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal))),
                TextButton(onPressed: () => controller.onInput(7), child: const Text("7", style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal))),
                TextButton(onPressed: () => controller.onInput(8), child: const Text("8", style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal))),
                TextButton(onPressed: () => controller.onInput(9), child: const Text("9", style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal))),
                const SizedBox(),
                TextButton(onPressed: () => controller.onInput(0), child: const Text("0", style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal))),
                IconButton(onPressed: () => controller.onBackspace(), icon: const Icon(Icons.backspace_outlined, size: 40))
              ],
            ),
          ),
        ),
        const SizedBox(height: 62),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: widget.onCancel, child: const Text("Cancel")),
            const SizedBox(width: 16),
            ElevatedButton(onPressed: () => widget.onConfirm?.call(controller.timeInSeconds), child: const Text("Confirm")),
          ],
        )
      ],
    );
  }
}