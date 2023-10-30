import 'package:countdown/widgets/time_input_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('onInput', () {
    TimeInputController controller = TimeInputController();
    controller.onInput(1);
    expect(controller.timeInSeconds, 1);
  });
}