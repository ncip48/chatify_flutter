// ignore_for_file: import_of_legacy_library_into_null_safe, file_names

import 'dart:convert';
import 'dart:developer';

import 'package:chat_flutter/pages/HomePage.dart';
import 'package:chat_flutter/pages/SigninPage.dart';
import 'package:chat_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:http/http.dart' as http;

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   // Optional clientId
//   // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
//   scopes: <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? _version;
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    getVersion();
    isLogin();
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String code = packageInfo.buildNumber;
    setState(() {
      _version = version + code;
    });
    log(_version!);
  }

  Future<void> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user');
    setState(() {
      _isLogin = user != null ? true : false;
    });
    if (user != null) {
      log(user);
    }
  }

  Future<void> callApiUpdateProfile(
      String token, GoogleSignInAccount? account) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'name': account!.displayName!,
        'photo': account.photoUrl!,
      }),
    );
    if (response.statusCode == 200) {
      log('success update profile');
    } else {
      log('failed update profile');
    }
  }

  Future<void> setSharedPreferences(String photo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'user',
        json.encode(<String, String>{
          'photo': photo,
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: _isLogin ? const HomePage() : SigninPage(),
      title: Text(
        'Chatify',
        textScaleFactor: 2,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: putih,
        ),
      ),
      loadingText: Text(
        'v ${_version ?? '0.0.0'}',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: background,
        ),
      ),
      photoSize: 100.0,
      backgroundColor: green,
      useLoader: false,
    );
  }
}
