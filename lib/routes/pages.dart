// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:chat_flutter/pages/DetailChatPage.dart';
import 'package:chat_flutter/pages/HomePage.dart';
import 'package:chat_flutter/pages/NewChatPage.dart';
import 'package:chat_flutter/pages/SigninPage.dart';
import 'package:chat_flutter/pages/SplashPage.dart';
import 'package:chat_flutter/routes/routes.dart';
import 'package:get/get.dart';

class AppPages {
  static const Initial = Routes.Root;

  static final routes = [
    GetPage(name: Routes.Root, page: () => SplashPage()),
    GetPage(name: Routes.Home, page: () => HomePage()),
    GetPage(name: Routes.Signin, page: () => SigninPage()),
    GetPage(name: Routes.NewChat, page: () => NewChatPage()),
    GetPage(name: Routes.Chat, page: () => DetailChatPage()),
  ];
}
