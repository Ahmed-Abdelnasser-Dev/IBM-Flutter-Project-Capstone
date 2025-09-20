// Only imported on web
import 'dart:html' as html;

void sendTestNotification() {
  if (html.Notification.permission != "granted") {
    html.Notification.requestPermission().then((permission) {
      if (permission == 'granted') {
        html.Notification("Habit Reminder",
            body: "It's time to work on your habits!");
        print('Notification permission granted. Notification sent.');
      } else {
        print('Notification permission denied.');
      }
    });
  } else {
    html.Notification("Habit Reminder",
        body: "It's time to work on your habits!");
    print('Notification sent directly.');
  }
}
