import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppText extends StatelessWidget {
  double size;
   final String text;
  final Color color;
  final FontWeight bold;

  AppText(
      {super.key,
        this.size = 25,
        required this.text,
        this.bold = FontWeight.normal,
        this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        textStyle: Theme.of(context).textTheme.headline4,
        color: color,
        fontSize: size.sp,
        fontWeight: bold,
      ),
    );
  }
}
