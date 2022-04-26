// ignore_for_file: unnecessary_null_comparison, unused_local_variable, avoid_print, non_constant_identifier_names, prefer_final_fields

// import 'package:chat_flutter/config/config.dart';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:chat_flutter/routes/pages.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: Random().nextInt(2147483647),
      channelKey: 'basic_channel',
      title: message.data['title'],
      body: message.data['body'],
      wakeUpScreen: true,
      fullScreenIntent: true,
      autoDismissible: false,
      category: NotificationCategory.Call,
      locked: true,
      displayOnForeground: true,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'accept',
        label: 'Accept',
      ),
      NotificationActionButton(
        isDangerousOption: true,
        key: 'reject',
        label: 'Reject',
      ),
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  AwesomeNotifications().initialize('resource://drawable/ic_icon', [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Chat Notification',
        channelDescription: 'For Chat',
        importance: NotificationImportance.High,
        channelShowBadge: true,
        vibrationPattern: highVibrationPattern),
  ]);

  runApp(const MyApp());
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String groupKey = 'CHATGROUP';
  static const String groupChannelId = 'channel_chat';
  static const String groupChannelName = 'Chat';
  // static const String groupChannelDescription = 'Chat Message';

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        print(notification.toString());
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                groupChannelId,
                groupChannelName,
                importance: Importance.max,
                priority: Priority.high,
                groupKey: groupKey,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chatify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppPages.Initial,
      getPages: AppPages.routes,
    );
  }
}
