// ignore_for_file: file_names, sized_box_for_whitespace, avoid_unnecessary_containers, avoid_print, prefer_final_fields, prefer_const_constructors, use_function_type_syntax_for_parameters, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:chat_flutter/config/config.dart';
import 'package:chat_flutter/models/Contacts.dart';
import 'package:chat_flutter/widget/ListChat.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  _MyNewChatPageState createState() => _MyNewChatPageState();
}

class _MyNewChatPageState extends State<NewChatPage> {
  String txtSearch = '';
  List<String> stories = [
    "Story 1",
    "Story 2",
    "Story 3",
    "Story 4",
    "Story 5",
    "Story 6",
    "Story 7",
    "Story 8"
  ];

  @override
  void initState() {
    super.initState();
    // getContacts();
    getContacts();
  }

  List<Contacts> _contactList = [];
  Future<void> getContacts() async {
    setState(() => {});
    final response = await getRequestAPI('users', 'get', null, context);
    log(response.toString());
    List<dynamic> values = response;
    List<Contacts> temp = [];
    if (values.isNotEmpty) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          temp.add(Contacts.fromJson(map));
          // log('Id-------${map['id']}');
        }
      }
    }
    print(_contactList.length);
    setState(() {
      _contactList = temp;
    });
  }

  Future<void> searchContacts() async {
    var body = jsonEncode(<String, String>{'name': txtSearch});
    final response = await getRequestAPI('search-users', 'post', body, context);
    log(response.toString());
    List<dynamic> values = response;
    List<Contacts> temp = [];
    if (values.isNotEmpty) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          if (!temp.contains(Contacts.fromJson(map))) {
            temp.add(Contacts.fromJson(map));
          }
          // log('Id-------${map['id']}');
        }
      }
    }
    print(_contactList.length);
    setState(() {
      _contactList = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    // final _height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF273A48),
      ),
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: putih,
            body: SafeArea(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                                left: 15,
                                right: 15,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Search Users',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    alignment: Alignment.centerRight,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            // height: 120.0,
                            width: _width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 10,
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    txtSearch = value;
                                  });
                                },
                                obscureText: false,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'type user here...',
                                  hintStyle: TextStyle(
                                      fontSize: 16, color: Colors.black45),
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: Icon(Icons.person, color: green),
                                  suffixIcon: Material(
                                    elevation: 0,
                                    color: green,
                                    shadowColor: Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                          searchContacts();
                                        },
                                        icon: Icon(Icons.search),
                                        color: Colors.white),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: green, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: green, width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              width: _width,
                              decoration: BoxDecoration(
                                color: putih,
                              ),
                              child: _contactList.isEmpty
                                  ? Center(
                                      child: Text('No User Found'),
                                    )
                                  : ListView.builder(
                                      itemCount: _contactList.length,
                                      itemBuilder: (context, index) {
                                        var contacts = _contactList[index];
                                        return ListChat(
                                          image: contacts.photo ??
                                              'https://www.nicepng.com/png/full/514-5146455_premium-home-loan-icon-download-in-svg-png.png',
                                          name: contacts.name!,
                                          chat: contacts.status!,
                                          time: '',
                                          me_send: contacts.recentChatMe!,
                                          data: contacts,
                                          onFetch: null,
                                        );
                                      },
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
