// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace, avoid_print, prefer_const_constructors

import 'package:chat_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyComponent extends StatelessWidget {
  final String image;
  final String title;

  EmptyComponent({required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(99.0),
              // shape: BoxShape.circle,
              color: Colors.transparent,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.fitHeight,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.6,
            child: Container(),
          ),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
