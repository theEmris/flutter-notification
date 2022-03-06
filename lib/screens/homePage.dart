import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AndroidInitializationSettings? initializationSettingsAndroid;
  IOSInitializationSettings? initializationSettingsIOS;
  InitializationSettings? initializationSettings;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int? day = DateTime.now().day, hour, minute;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');
    initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, subtitle, content) {});
    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings!,
        onSelectNotification: (v) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => Scaffold(
            appBar: AppBar(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await showDatePicker(
          //   context: context,
          //   initialDate: DateTime.now(),
          //   firstDate: DateTime(2022, 01, 01, 0, 0),
          //   lastDate: DateTime(2025),
          // ).then((value) async {
          //   day = value!.day;
          //   await showTimePicker(context: context, initialTime: TimeOfDay.now())
          //       .then((value) {
          //     hour = value!.hour;
          //     minute = value.minute;
          //   });
          //   a(day!, hour!, minute!);
          // });
          b();
        },
        child: const Icon(Icons.send),
      ),
    );
  }

  // ? function for Android
  b() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  // ? function for Ios
  a(int day, int hour, int minute) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Eslatma',
        'body',
        tz.TZDateTime.from(
          DateTime(2022, 1, day, hour, minute),
          tz.getLocation('Africa/Algiers'),
        ),
        const NotificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}