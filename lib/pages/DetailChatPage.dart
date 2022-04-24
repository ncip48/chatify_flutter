// ignore_for_file: prefer_const_constructors, file_names, avoid_print, prefer_const_literals_to_create_immutables

import 'package:chat_flutter/config/config.dart';
import 'package:chat_flutter/models/Contacts.dart';
import 'package:chat_flutter/models/Message.dart';
import 'package:chat_flutter/utils/colors.dart';
import 'package:chat_flutter/widget/ListMessage.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

class DetailChatPage extends StatefulWidget {
  const DetailChatPage({Key? key}) : super(key: key);

  @override
  _DetailChatPageState createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  final Contacts data = Get.arguments;
  List<Message> _messages = [];
  String _txtChat = '';

  @override
  void initState() {
    super.initState();
    getChats();
  }

  Future<void> getChats() async {
    setState(() => {});
    final response =
        await getRequestAPI('chat/' + data.id.toString(), 'get', null, context);
    // log(response.toString());
    List<dynamic> values = response;
    List<Message> temp = [];
    if (values.isNotEmpty) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          temp.add(Message.fromJson(map));
          // log('Id-------${map['id']}');
        }
      }
    }
    print(_messages.length);
    setState(() {
      _messages = temp;
    });
  }

  Future<void> sendChat() async {}

  Widget _buildMessageComposer() {
    return Container(
      height: 70.0,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo),
            color: green,
            iconSize: 25.0,
            onPressed: () {},
          ),
          Expanded(
              child: TextField(
            onChanged: (value) {
              setState(() {
                _txtChat = value;
              });
            },
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: "Send a message ...",
              border: InputBorder.none,
            ),
          )),
          IconButton(
            icon: Icon(Icons.send),
            color: green,
            iconSize: 25.0,
            onPressed: () {
              sendChat();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      appBar: AppBar(
        backgroundColor: green,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Center(
          child: Column(children: [
            Text(
              data.name!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              data.status!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ]),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, size: 25.0),
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  child: ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.only(top: 15.0),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final Message message = _messages[index];
                        return ListMessage(message: message);
                      }),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
