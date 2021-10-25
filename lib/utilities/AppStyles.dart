import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles{

  static TextStyle titleStyleWhite = GoogleFonts.quicksand(
    textStyle: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: .5),
  );

  static TextStyle titleStyleBlack = GoogleFonts.quicksand(
    textStyle: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        letterSpacing: .5),
  );

  static TextStyle buttonStyleWhite = GoogleFonts.quicksand(
    textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: .5),
  );

  static TextStyle buttonStyleBlack = GoogleFonts.quicksand(
    textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        letterSpacing: .5),
  );

  static TextStyle tableHeaderStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  static TextStyle tableBodyStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    color: Colors.black54,
    fontSize: 12,
  );

  getTitleStyle({titleSize,titleColor,titleWeight}){
    return GoogleFonts.quicksand(
      textStyle: TextStyle(
          fontSize: titleSize,
          fontWeight: titleWeight,
          color: titleColor,
          letterSpacing: .5),
    );
  }
}