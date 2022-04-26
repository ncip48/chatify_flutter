// ignore_for_file: prefer_const_constructors, file_names, avoid_print, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe

import 'dart:convert';
// import 'dart:io';

import 'package:chat_flutter/config/config.dart';
import 'package:chat_flutter/models/Contacts.dart';
import 'package:chat_flutter/models/Message.dart';
import 'package:chat_flutter/utils/colors.dart';
import 'package:chat_flutter/widget/ListMessage.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pusher_websocket_flutter/pusher.dart';

class DetailChatPage extends StatefulWidget {
  const DetailChatPage({Key? key}) : super(key: key);

  @override
  _DetailChatPageState createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  final Contacts data = Get.arguments;
  List<Message> _messages = [];
  String _txtChat = '';
  final TextEditingController _textController = TextEditingController();
  bool isShowSticker = false;
  late Event lastEvent;
  late String lastConnectionState;
  late Channel channel;

  @override
  void initState() {
    super.initState();
    getChats();
    initiatePusher();
  }

  Future<void> initiatePusher() async {
    print(data.targetChat);
    try {
      await Pusher.init("ac7dc4b6a55944da66e6", PusherOptions(cluster: "ap1"),
          enableLogging: true);
      await Pusher.connect(onConnectionStateChange: (x) async {
        print(x.currentState);
      }, onError: (x) {
        print("Error: ${x.message}");
      });
      channel = await Pusher.subscribe(data.targetChat!);
      await channel.bind("chat.sent", (x) {
        Map<String, dynamic> map = json.decode(x.data);
        var data = map['message'];
        var other = map['other'];
        Message input = Message(
          id: 9,
          message: data['message'],
          userId: data['user_id'],
          targetId: data['target_id'],
          targetUserId: data['target_id'],
          status: other['status'],
          createdAt: data['created_at'],
          attachment: data['attachment'],
          isRead: data['is_read'],
          isRetracted: data['is_retracted'],
          recentChatMe: other['recent_chat_me'],
          timeParse: other['time_parse'],
          isPending: false,
        );
        print(data);
        appendChat(input);
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
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

  Future<void> _sendChat() async {
    _textController.clear();
    sendChat();
  }

  Future<void> sendChat() async {
    Message input = Message(
      id: _messages.length + 1,
      message: _txtChat.toString(),
      userId: 1,
      targetId: data.id,
      targetUserId: data.id,
      status: "sent",
      createdAt: DateTime.now().toString(),
      attachment: null,
      isRead: 0,
      isRetracted: 0,
      recentChatMe: true,
      timeParse: getFormatedTime(
        DateTime.now().toString(),
      ),
      isPending: true,
    );
    await appendChat(input);
    var body = jsonEncode(input);
    final response = await getRequestAPI('chat', 'post', body, context);
    // print(response);
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

  Future<void> appendChat(Message input) async {
    List<Message> temp = _messages;
    temp.insert(0, input);
    setState(() {
      _messages = temp;
      _txtChat = '';
    });
  }

  Future<void> openCloseEmoji() async {
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  @override
  void dispose() {
    super.dispose();
    // Unsubscribe from channel
    Pusher.unsubscribe(data.targetChat!);
    // channel.unbind("chat.sent");
  }

  // _onEmojiSelected(Emoji emoji) {
  //   _textController
  //     ..text += emoji.emoji
  //     ..selection = TextSelection.fromPosition(
  //         TextPosition(offset: _textController.text.length));
  // }

  // _onBackspacePressed() {
  //   _textController
  //     ..text = _textController.text.characters.skipLast(1).toString()
  //     ..selection = TextSelection.fromPosition(
  //         TextPosition(offset: _textController.text.length));
  // }

  Widget _buildMessageComposer() {
    return Container(
      height: 70.0,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.insert_emoticon),
            color: isShowSticker ? green : Colors.grey,
            iconSize: 25.0,
            onPressed: () {
              openCloseEmoji();
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.photo),
          //   color: green,
          //   iconSize: 25.0,
          //   onPressed: () {},
          // ),
          Expanded(
            child: TextField(
              controller: _textController,
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
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: _txtChat.isEmpty ? Colors.grey : green,
            iconSize: 25.0,
            onPressed: () {
              _txtChat.isEmpty ? null : _sendChat();
            },
          ),
        ],
      ),
    );
  }

  Widget buildSticker() {
    return EmojiPicker(
      onEmojiSelected: (emoji, category) {
        print(emoji);
      },
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
          child: WillPopScope(
            onWillPop: onBackPress,
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
