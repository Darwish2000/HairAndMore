import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'appText.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onPressed;
  double textSize;

  AppButton({
    Key? key,
    required this.text,
    this.width = double.maxFinite,
    this.height = 7,
    required this.onPressed,
    this.textSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)))),
        onPressed: onPressed,

        child: AppText(
          text: text,
          color: Colors.black,
          size: textSize,
        ),
      ),
    );
  }
}
