import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class WaitingAdminPage extends StatelessWidget {
  const WaitingAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
            Image.asset(
              "images/logo.png",
              fit: BoxFit.cover,
              width: 55.w,
              height: 25.h,
            ),
            const Text('Your profession certificate request has been sent to the platform admin please wait for approval.',style: TextStyle(fontSize: 20),)
          ],),
        ),
      ),
    );
  }
}