import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  static final Notifications _notificationService = Notifications._internal();

  factory Notifications() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Notifications._internal();

  final NotificationDetails notificationDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      // 'Main channel notifications',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@drawable/launcher_icon',
      color: Colors.red,
      enableVibration: true,
    ),
    iOS: IOSNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  Future<void> cancelIdNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin localNotifications,
      int id,
      String title,
      String body,

      String payload) async {
    await localNotifications.show(id, title, body, notificationDetails,
        payload: body ?? '');
  }

  Future<void> scheduleNotification(
      FlutterLocalNotificationsPlugin localNotifications,
      int id,
      String title,
      String body,
      DateTime dateTime,
      String payload) async {
    await localNotifications.schedule(
        id, title, body, dateTime, notificationDetails,
        payload: payload ?? '');
  }

  Future<void> zonedScheduleNotification(
      FlutterLocalNotificationsPlugin localNotifications,
      int id,
      String title,
      String body,
      int seconds,
      String payload) async {
    await localNotifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(const Duration(hours: 24)),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: payload ?? '');
  }

  Future<void> periodicallyShowNotification(
      FlutterLocalNotificationsPlugin localNotifications,
      int id,
      String title,
      String body,
      RepeatInterval repeatInterval,
      String payload) async {
    await localNotifications.periodicallyShow(
        id, title, body, repeatInterval, notificationDetails,
        payload: payload ?? '');
  }

  Future<void> showDailyAtTimeNotification(
      FlutterLocalNotificationsPlugin localNotifications,
      int id,
      String title,
      String body,
      Time time,
      String payload) async {
    await localNotifications.showDailyAtTime(
        id, title, body, time, notificationDetails,
        payload: payload ?? '');
  }



  Future<void> showWeeklyAtDayAndTimeNotification(
      FlutterLocalNotificationsPlugin localNotifications,
      int id,
      String title,
      String body,
      Day day,
      Time time,
      String payload) async {
    await localNotifications.showWeeklyAtDayAndTime(
        id, title, body, day, time, notificationDetails,
        payload: payload ?? '');
  }
}