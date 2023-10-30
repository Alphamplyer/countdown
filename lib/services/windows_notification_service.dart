import 'package:uuid/uuid.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';

class WindowsNotificationService {
  static final _winNotifyPlugin = WindowsNotification(applicationId: "Countdown");
  static const Uuid _uuid = Uuid();

  static void notifyEndOfCountdown() {
    NotificationMessage message = NotificationMessage.fromPluginTemplate(
      _uuid.v4(), 
      "Countdown Finished", 
      "Your countdown has finished ! Return to the app to start a new one.",
    );
    
    _winNotifyPlugin.showNotificationPluginTemplate(message);
  }
}