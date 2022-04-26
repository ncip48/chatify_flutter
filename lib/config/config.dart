// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:chat_flutter/routes/routes.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

String appSecret = 'uTLMdxSKJhNJvZH87BkQnUUMMgytg8nm';

getUUID() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
  return androidDeviceInfo.androidId;
}

getIrsauth() async {
  String _uuid = await getUUID();
  String combine = appSecret + _uuid;
  combine = md5.convert(utf8.encode(combine)).toString();
  combine = md5.convert(utf8.encode(combine)).toString();
  return md5.convert(utf8.encode(combine)).toString();
}

String urlHost = "https://06e9-118-99-83-91.ap.ngrok.io";

getRequestAPI(String prefix, String method, Object? body, context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var getPrefs = prefs.getString('user');
  Map<String, dynamic> map = json.decode(getPrefs!);
  var token = map['token'];
  String url = urlHost;
  // String url = "https://06e9-118-99-83-91.ap.ngrok.io";
  // if (kDebugMode) {
  //   url = 'http://10.0.2.2:8000';
  //   // url = 'http://192.168.18.33';
  // } else {
  //   url = 'https://06e9-118-99-83-91.ap.ngrok.io/';
  // }
  switch (method) {
    case 'post':
      final response = await http.post(
        Uri.parse('$url/api/$prefix'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        log('success fetch api $url');
        Map<String, dynamic> map = json.decode(response.body);
        if (map['message'].toString().contains('Unauthorized')) {
          log('Unauthorized');
          prefs.remove('user');
          return Navigator.of(context).pushNamed(Routes.Signin);
        }
        return map['data'];
      } else {
        log(response.body);
        log('failed fetch api $url');
      }
      break;
    case 'patch':
      final response = await http.patch(
        Uri.parse('$url/api/$prefix'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        log('success fetch api $url');
        Map<String, dynamic> map = json.decode(response.body);
        if (map['message'].toString().contains('Unauthorized')) {
          log('Unauthorized');
          prefs.remove('user');
          return Navigator.of(context).pushNamed(Routes.Signin);
        }
        return map['data'];
      } else {
        log(response.body);
        log('failed fetch api $url');
      }
      break;
    case 'get':
      final response = await http.get(
        Uri.parse('$url/api/$prefix'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        log('success fetch api $url');
        Map<String, dynamic> map = json.decode(response.body);
        if (map['message'].toString().contains('Unauthorized')) {
          log('Unauthorized');
          prefs.remove('user');
          return Navigator.of(context).pushReplacementNamed(Routes.Signin);
        }
        return map['data'];
      } else {
        log(response.body);
        log('failed fetch api $url');
      }
      break;
    default:
  }
}

getFormatedTime(_date) {
  DateTime x = DateTime.parse(_date);
  String date = DateFormat.Hm().format(x);
  return date;
}

getToken() async {
  var token = (await FirebaseMessaging.instance.getToken())!;
  return token;
}
