import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hair_and_more/Views/Authentication/sign_in_page.dart';
import 'package:hair_and_more/utils/restService.dart';
import 'package:hair_and_more/utils/user_preferences.dart';
import 'package:http/http.dart' as http;

import 'apiPaths.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
  tooManyRequests,
}

class AuthExceptionHandler {
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
        errorMessage = "The email address is already in use by another account.";
        break;
      case AuthStatus.tooManyRequests:
        errorMessage = "Too many requests to log into this account.";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}

abstract class AuthenticationHelper {
  static addCustomerInfo(data) async {
    log(data.toString());
    var result = await RestApiService.patch(
      ApiPaths.getAddCustomerInfo,
      data,
    );
    log('addCustomerInfo ${result.statusCode} ${result.body}');
    if (result.statusCode < 300) {
      log('addCustomerInfo ${result.statusCode} ${result.body}');
      return result;
    } else {
      return null;
    }
  }

  static Future<http.Response> updateCustomerInfo(data) async {
    log(data.toString());
    var result = await RestApiService.patch(
      ApiPaths.getUpdateCustomerInfo,
      data,
    );
    return result;
  }

  //SIGN UP METHOD
  static Future signUpEmail(String email, String password) async {
    try {
      var crid = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) => sendVerificationEmail());
      return crid;
    } on FirebaseAuthException catch (e) {
      log('AuthenticationHelper signUpEmail $email  $password');
      log('FirebaseAuthException ${e.message}');
      return e.message;
    }
  }
  static void sendVerificationEmail() async
   {
     try{
       final user = FirebaseAuth.instance.currentUser!;
       await user.sendEmailVerification();
     } catch(e) {

     }
   }
  //SIGN IN METHOD
  static Future signInEmail(String email, String password) async {
    try {
      var firebaseUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (firebaseUser.user != null) {
        await UserPreferences.storeValue('UID', firebaseUser.user!.uid);
      }
      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  //SIGN OUT METHOD
  static Future signOutEmail() async {
    await FirebaseAuth.instance.signOut();
    await UserPreferences.clearStorage();
    print('signout');
  }

  // static Future<dynamic> signInWithGoogle() async {
  //   try {
  //     UserCredential? userCredential;
  //
  //     FirebaseAuth auth = FirebaseAuth.instance;
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     if (googleUser != null) {
  //       // Obtain the auth details from the request
  //       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //       // Create a new credential
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //
  //       var token = await FirebaseMessaging.instance.getToken();
  //
  //       userCredential = await auth.signInWithCredential(credential);
  //
  //       User? user = userCredential.user;
  //
  //       if (user != null) {
  //         var data = {
  //           'UID': user.uid,
  //           'CUSTOMER_EMAIL': user.email,
  //           "FCM_TOKEN": token,
  //         };
  //
  //         var result = await RestApiService.post(
  //           ApiPaths.getRegistration,
  //           data,
  //         );
  //         await UserPreferences.storeValue('UID', user.uid);
  //         Map<String, dynamic> userMap = jsonDecode(result.body);
  //         await UserPreferences.storeValue('CUSTOMER_ID', userMap['CUSTOMER_ID'].toString());
  //       }
  //     }
  //     return userCredential;
  //   } on FirebaseAuthException catch (e) {
  //     log('AuthenticationHelper signInWithGoogle');
  //     log('FirebaseAuthException ${e.message}');
  //     return e.message;
  //   }
  // }


  static changePassword(String newPassword, BuildContext ctx) async {
    log('changePassword with ' + newPassword);
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
        signOutEmail();
      }
      return true;
    } catch (e) {
      log('try catch changePassword ${e.toString()}');
      return onFirebaseError(e, ctx: ctx);
    }
  }

  static onFirebaseError(var error, {BuildContext? ctx}) async {
    log("caught onerror firebase ${error.runtimeType} \n ${error.toString()}");

    if (error is FirebaseAuthException) {
      /*     await FirebaseAuth.instance.signOut();
      if (await GoogleSignIn().isSignedIn()) await GoogleSignIn().disconnect();*/
      String err;
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          err = "Email already used.";
          break;

        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          err = "Wrong email/password combination.";
          break;

        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          err = "No user found with this email.";
          break;

        case "ERROR_USER_DISABLED":
        case "user-disabled":
          err = "User disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          err = "Too many requests to log into this account.";
          break;

        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          err = "Server error, please try again later.";
          break;

        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          err = "Email address is invalid.";
          break;

        case "weak-password":
          err = "Your password is too weak, must be 6 characters or more";
          break;
        case "requires-recent-login":
          err = error.message ?? "login again";
          redirectToLogin(ctx);
          break;
        default:
          err = "Login failed. Please try again.";
          break;
      }
      log("catch switch statement res ${err}");

      return err;
    }
  }

  static Future<AuthStatus> resetPassword(String email) async {
    late AuthStatus status;
    print(email);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim()).then((value) {
        log("firebase password reset");

        return status = AuthStatus.successful;
      }).catchError((e) {
        status = AuthExceptionHandler.handleAuthException(e);
        log('resetPassword $e');
      });
      return status;
    } catch (e) {

      return status;
    }
  }

  static AuthChanges() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  static void redirectToLogin(BuildContext? ctx) async {
    if (ctx != null)
      await Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(
          builder: (context) => SignInPage(),
        ),
        (route) => false,
      );
  }
}