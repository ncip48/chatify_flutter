// ignore_for_file: file_names, sized_box_for_whitespace, avoid_unnecessary_containers, avoid_print, prefer_final_fields, prefer_const_constructors

import 'dart:developer';

import 'package:chat_flutter/config/config.dart';
import 'package:chat_flutter/models/Contacts.dart';
import 'package:chat_flutter/routes/routes.dart';
import 'package:chat_flutter/widget/EmptyComponent.dart';
import 'package:chat_flutter/widget/ListChat.dart';
import 'package:chat_flutter/widget/ListStory.dart';
import 'package:chat_flutter/widget/PlaneIndicator.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<String> stories = [
    "Aini ♡",
  ];

  @override
  void initState() {
    super.initState();
    getContacts(true);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    var _isInForeground = state == AppLifecycleState.resumed;
    print('in foreground ~> ' + _isInForeground.toString());
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  List<Contacts> _contactList = [];
  bool _isLoading = true;
  Future<void> getContacts(bool useLoading) async {
    var token = await getToken();
    print('token ~>' + token);
    if (useLoading) {
      setState(() {
        _isLoading = true;
      });
    }
    final response = await getRequestAPI('contacts', 'get', null, context);
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
      _isLoading = false;
    });
  }

  Future<void> onRefresh() async {
    await getContacts(true);
  }

  refreshBack() async {
    await getContacts(false);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    // final _height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF273A48),
      ),
      child: PlaneIndicator(
        onAction: () => refreshBack(),
        child: Stack(
          children: <Widget>[
            Scaffold(
              backgroundColor: green,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: AppBar(
                  backgroundColor: green,
                  elevation: 0,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(Routes.NewChat)
                      .then((value) => getContacts(false));
                },
                child: const Icon(Icons.add),
                backgroundColor: green,
              ),
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Chatify',
                                      style: GoogleFonts.poppins(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: putih,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.account_circle,
                                      size: 30,
                                      color: putih,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 120.0,
                              width: _width,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 5.0,
                                      top: 0.0,
                                      bottom: 4.0,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        print('Card selected');
                                      },
                                      child: Container(
                                        width: 60,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: putih,
                                                border: Border.all(
                                                  color: putih,
                                                  width: 1.0,
                                                ),
                                              ),
                                              width: 70,
                                              height: 70,
                                              child: const Icon(
                                                Icons.add,
                                                color: green,
                                                size: 40,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                'Add',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: putih,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: _width - 80,
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        EdgeInsets padding = index == 0
                                            ? const EdgeInsets.only(
                                                left: 20.0,
                                                right: 10.0,
                                                top: 0.0,
                                                bottom: 20.0,
                                              )
                                            : const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                top: 0.0,
                                                bottom: 20.0,
                                              );

                                        return ListStory(
                                            image:
                                                'https://picsum.photos/250?image=9',
                                            name: stories[index],
                                            count: 3,
                                            padding: padding);
                                      },
                                      scrollDirection: Axis.horizontal,
                                      itemCount: stories.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                width: _width,
                                decoration: BoxDecoration(
                                  color: putih,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    topLeft: Radius.circular(30.0),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    topLeft: Radius.circular(30.0),
                                  ),
                                  child: _isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: green,
                                          ),
                                        )
                                      : _contactList.isEmpty
                                          ? Center(
                                              child: EmptyComponent(
                                                  image:
                                                      "https://i.ibb.co/c6S1rqK/2992779.jpg",
                                                  title:
                                                      "No contacts found, please start chat by clicking + in bottom right menu"),
                                            )
                                          : ListView.builder(
                                              itemCount: _contactList.length,
                                              itemBuilder: (context, index) {
                                                var contacts =
                                                    _contactList[index];
                                                return ListChat(
                                                  image: contacts.photo ??
                                                      'https://www.nicepng.com/png/full/514-5146455_premium-home-loan-icon-download-in-svg-png.png',
                                                  name: contacts.name!,
                                                  chat: contacts
                                                      .recentChat!.message!,
                                                  time: contacts
                                                      .recentChat!.timeParse!,
                                                  me_send:
                                                      contacts.recentChatMe!,
                                                  data: contacts,
                                                  onFetch: () => refreshBack(),
                                                );
                                              },
                                            ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
