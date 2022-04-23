// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace, avoid_print

import 'package:chat_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListStory extends StatelessWidget {
  final String image;
  final String name;
  final int count;
  final EdgeInsets padding;

  ListStory(
      {required this.image,
      required this.name,
      required this.count,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: () {
          print('Card selected');
        },
        child: Container(
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(99.0),
            shape: BoxShape.circle,
            color: Colors.transparent,
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.fitHeight,
            ),
          ),
          width: 60,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 15.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: putih,
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
