import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hair_and_more/Views/Authentication/barberAuthPages/pickPdfFilePage.dart';
import 'package:hair_and_more/Views/barberPages/mapPage.dart';
import '../Views/barberPages/waitingAdminPage.dart';
import '../models/barber.dart';
import '../models/slot.dart';
import '../utils/auth.dart';

class AuthProv with ChangeNotifier {
  PlatformFile? file;
  bool isSelected = false;
  final formKey = GlobalKey<FormBuilderState>();
  String? phoneNo = '';
  bool valid = true;
  String verify ='';
  String smsCode ='';
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      case "too-many-requests":
        status = AuthStatus.tooManyRequests;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your email or password is wrong.";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
            "The email address is already in use by another account.";
        break;
      case AuthStatus.tooManyRequests:
        errorMessage = "Too many requests to log into this account.";
        break;
      default:
        errorMessage = "An error occurred. Please try again later.";
    }
    return errorMessage;
  }

  static signUpWithEmail(var data, BuildContext context) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      credential.user!.sendEmailVerification();
      if (data['type'] == 0) {
        await addUserDetails(data, credential.user!.uid);
        // await showDialog(
        //     context: context,
        //     builder: (context) => AlertDialog(
        //           content: const Text('verify your email'),
        //           actions: [
        //             TextButton(
        //                 onPressed: () {
        //                   Navigator.pop(context);
        //                 },
        //                 child: const Text('ok'))
        //           ],
        //         ));
      } else {
        await addBarberDetails(data, credential.user!.uid);
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  content: Text('The password provided is too weak.'),
                ));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  content: Text('The account already exists for that email.'),
                ));
        print('The account already exists for that email.');
      } else {
        print('print exception ${e.code}');
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text(e.toString()),
              ));
    }
  }

  static Future addUserDetails(var data, var uid) async {
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'firstName': data['firstName'],
      'lastName': data['lastName'],
      'email': data['email'],
      'gender': data['gender'],
      'token': token,
      'image': ''
    });
  }
  static Future addBarberDetails(var data, var uid) async {
    String? token = await FirebaseMessaging.instance.getToken();
    List<Slot> slots = Slot.setBarberSlots();
    print(data['gender']);
    Barber? barber = Barber(
        uid: uid,
        firstName: data['firstName'],
        lastName: data['lastName'],
        gender: data['gender'],
        reviews: 0,
        rating: 1,
        email: data['email'],
        barberStatus: 1,
        image: '',
        phoneNo: '',
        longitude: 0,
        latitude: 0,
        token: token!,
        slots: slots);
    await FirebaseFirestore.instance.collection('barbers').doc(uid).set(
          barber.toJson(),
        );
  }

  static signInWithEmail(String email, String psw, BuildContext ctx) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: psw);

      if (!credential.user!.emailVerified) {
        return false;
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(ctx)
            .showSnackBar(const SnackBar(content: Text('user not found')));
        return -1;
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user')));
        return -1;
      }
    }
  }

  static resetPsw(String email) async {
    return await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  savePdfFile(PlatformFile file) {
    print("file name : ${file.name}");
    print("file bytes : ${file.bytes}");
    print("file size : ${file.size}");
    print("file path : ${file.path}");
    this.file = file;
    isSelected = true;
    notifyListeners();
  }

  uploadFile(String barberId,BuildContext context) async {
    final path = 'barberFiles/$barberId';
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(File(file!.path!));
    await FirebaseFirestore.instance.collection('barbers').doc(barberId).update({
      'barberStatus':4
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WaitingAdminPage()));
  }

  static getBarberLocation() async {
    await Geolocator.requestPermission();
    Position loc = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return loc;
  }

  void addPhoneNum(String? phoneNumber) {
    phoneNo = phoneNumber;
    print(phoneNo);
    notifyListeners();
  }

  otpFunction(BuildContext context) async {
    print('$phoneNo /// ${phoneNo!.length}');
    var id =FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('barbers').doc(id).update({
      'barberStatus': 2,
      'phoneNo':phoneNo
    });
    Position location = await AuthProv
        .getBarberLocation();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MapPage(latitude: location.latitude,longitude: location.longitude),));

  }


  void putSmsCode(String pin) {
    smsCode = pin;
    notifyListeners();
  }

   static putBarberLocation(BuildContext context,double latitude,double longitude) async {
    var id = FirebaseAuth.instance.currentUser!.uid;
    print(id);
   await FirebaseFirestore.instance.collection('barbers').doc(id).update({
     'barberStatus':3,
     'latitude': latitude,
     'longitude':longitude
   });
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PickPdfFilePage(id),) );
  }
}
