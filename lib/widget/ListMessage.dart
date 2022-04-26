// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace, avoid_print, prefer_const_constructors

import 'package:chat_flutter/models/Message.dart';
import 'package:chat_flutter/utils/colors.dart';
import 'package:flutter/material.dart';

class ListMessage extends StatelessWidget {
  final Message message;

  ListMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final msg = Container(
      // width: MediaQuery.of(context).size.width * 0.75,
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      margin: message.recentChatMe!
          ? EdgeInsets.only(top: 2.0, bottom: 2.0, left: 10.0, right: 10)
          : EdgeInsets.only(top: 2.0, bottom: 2.0, right: 10.0, left: 10),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: message.recentChatMe! ? green : Color(0xFFFFEFEE),
        borderRadius: message.recentChatMe!
            ? BorderRadius.all(
                Radius.circular(15),
              )
            : BorderRadius.all(
                Radius.circular(15),
              ),
      ),
      child: Column(
        crossAxisAlignment: message.recentChatMe!
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            message.message!,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: message.recentChatMe! ? putih : Colors.blueGrey,
            ),
          ),
          SizedBox(height: 4.0),
          if (message.recentChatMe!)
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.timeParse!,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                    color: message.recentChatMe! ? background : Colors.blueGrey,
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  message.isRead == 1
                      ? Icons.done_all
                      : message.isPending!
                          ? Icons.schedule
                          : Icons.check,
                  color: message.isRead == 1 ? Colors.yellow : putih,
                  size: 15.0,
                )
              ],
            )
          else
            Text(
              message.timeParse!,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
                color: message.recentChatMe! ? background : Colors.blueGrey,
              ),
            ),
        ],
      ),
    );

    // if (message.recentChatMe!) return msg;

    return Row(
      mainAxisAlignment: message.recentChatMe!
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        msg,
      ],
    );
  }
}
