// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_constructors

import 'package:chat_flutter/models/Contacts.dart';
import 'package:chat_flutter/routes/routes.dart';
import 'package:chat_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListChat extends StatelessWidget {
  final String image;
  final String name;
  final String chat;
  final String? time;
  final bool me_send;
  final Contacts data;
  final Function? onFetch;

  ListChat(
      {required this.image,
      required this.name,
      required this.chat,
      required this.time,
      required this.me_send,
      required this.data,
      required this.onFetch});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.Chat, arguments: data)
                .then((value) => onFetch!());
          },
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: const BoxDecoration(
              color: putih,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                    child: Container(
                      width: 50,
                      height: 50,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        image,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                if (me_send)
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      0,
                                      6,
                                      0,
                                    ),
                                    child: Icon(
                                      data.recentChat!.isRead == 1
                                          ? Icons.done_all
                                          : Icons.check,
                                      color: data.recentChat!.isRead! == 1
                                          ? Colors.yellow
                                          : green,
                                      size: 16,
                                    ),
                                  ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    chat,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Text(
                          time!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          height: 0.5,
          thickness: 1,
          // color: green,
        ),
      ],
    );
  }
}
