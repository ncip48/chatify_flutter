// ignore_for_file: file_names, sized_box_for_whitespace, avoid_unnecessary_containers, avoid_print, prefer_final_fields, prefer_const_constructors

import 'dart:developer';

import 'package:chat_flutter/config/config.dart';
import 'package:chat_flutter/models/Contacts.dart';
import 'package:chat_flutter/widget/ListChat.dart';
import 'package:chat_flutter/widget/ListStory.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  _MyNewChatPageState createState() => _MyNewChatPageState();
}

class _MyNewChatPageState extends State<NewChatPage> {
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
    futureContact = getContacts();
  }

  List<Contacts> _contactList = [];
  late Future<List<Contacts>> futureContact;
  Future<List<Contacts>> getContacts() async {
    final response = await getRequestAPI('users', 'get', null, context);
    log(response.toString());
    List<dynamic> values = response;
    if (values.isNotEmpty) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          _contactList.add(Contacts.fromJson(map));
          // log('Id-------${map['id']}');
        }
      }
    }
    print(_contactList.length);
    return _contactList;
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    // final _height = MediaQuery.of(context).size.height;

    final body = Scaffold(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Search Users',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
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
                          vertical: 15,
                        ),
                        child: TextFormField(
                          obscureText: true,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: 'Aini...',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black45),
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
                              child: Icon(Icons.search, color: Colors.white),
                            ),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: green, width: 2.0),
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
                        child: FutureBuilder<List<Contacts>>(
                          future: futureContact,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemBuilder: (context, index) {
                                  Contacts contacts = snapshot.data![index];
                                  return ListChat(
                                    image: 'https://picsum.photos/seed/651/600',
                                    name: contacts.name!,
                                    chat: contacts.status!,
                                    time: contacts.createdAt!,
                                    me_send: contacts.recentChatMe!,
                                  );
                                },
                                itemCount: snapshot.data?.length,
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            return Center(
                              child: CircularProgressIndicator(),
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
    );

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF273A48),
      ),
      child: Stack(
        children: <Widget>[
          body,
        ],
      ),
    );
  }
}
