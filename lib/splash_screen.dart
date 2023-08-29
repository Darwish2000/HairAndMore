import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hair_and_more/Views/Authentication/barberAuthPages/phoneNoPage.dart';
import 'package:hair_and_more/Views/Authentication/barberAuthPages/pickPdfFilePage.dart';
import 'package:hair_and_more/Views/Authentication/sign_in_page.dart';
import 'package:hair_and_more/Views/barberPages/mapPage.dart';
import 'package:hair_and_more/Views/barberPages/waitingAdminPage.dart';
import 'package:hair_and_more/controllers/authProv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../utils/user_preferences.dart';
import 'Views/barberPages/barberHomePage.dart';
import 'Views/userPages/homePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      check_if_already_login();
    });
  }

  void check_if_already_login() async {
    // var firebaseUser = FirebaseAuth.instance.currentUser != null;
    // log('check_if_already_login firebaseUser $firebaseUser');
    if (await UserPreferences.checkIfValueExist('UID')) {
      String? uid = await UserPreferences.retrieveValue('UID');
      print(uid);
      final result = await FirebaseFirestore.instance.collection('barbers').get();

      for (var data in result.docs) {
        if(data.id == uid)
        {
          if(data.data()['barberStatus'] == 1)
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PhoneNoPage(),));
              return;
            }
          if(data.data()['barberStatus'] == 2)
          {
            Position location =  await AuthProv.getBarberLocation();
            print(location.latitude);
            print(location.longitude);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MapPage(latitude: location.latitude, longitude: location.longitude),));
            return;
          }
          if(data.data()['barberStatus'] == 3)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PickPdfFilePage(data.id),));
            return;
          }
          if(data.data()['barberStatus'] == 4)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WaitingAdminPage(),));
            return;
          }
          if(data.data()['barberStatus'] == 5)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BarberHomePage(),));
            return;
          }
        
        }
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>  HomePage()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) =>const SignInPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return     Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "images/logo.png",
                    fit: BoxFit.cover,
                    width: 45.w,
                    height: 25.h,
                  ),
                  SizedBox(height: 1.h,),
                  const CircularProgressIndicator(color: Colors.black,)
                ],
              ),
            ),
          );
  }
}