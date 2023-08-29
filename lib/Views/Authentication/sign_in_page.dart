import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hair_and_more/Views/Authentication/barberAuthPages/pickPdfFilePage.dart';
import 'package:hair_and_more/Views/Authentication/reset_password_page.dart';
import 'package:hair_and_more/Views/Authentication/sign_up_page.dart';
import 'package:hair_and_more/Views/barberPages/barberHomePage.dart';
import 'package:hair_and_more/Views/barberPages/waitingAdminPage.dart';
import 'package:hair_and_more/controllers/authProv.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../utils/user_preferences.dart';
import '../../widgets/appButton.dart';
import '../../widgets/appText.dart';
import '../../widgets/formTextField.dart';
import '../barberPages/mapPage.dart';
import '../userPages/homePage.dart';
import 'barberAuthPages/phoneNoPage.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormBuilderState>();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: FormBuilder(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "images/logo.png",
                    fit: BoxFit.cover,
                    width: 55.w,
                    height: 25.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppText(text: 'Sign in',
                        color: Colors.black,
                        bold: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  FormTextField(
                      text: 'Email',
                      icon: const Icon(Icons.email),
                      name: 'email',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.email(
                            errorText: 'please enter valid email'
                        ),
                        FormBuilderValidators.required(
                            errorText: 'email required'
                        )
                      ])
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  FormTextField(
                      text: 'Password',
                      icon: const Icon(Icons.lock),
                      name: 'password',
                      isSecure: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Password required'
                        ),
                        FormBuilderValidators.minLength(6,
                            errorText: 'The password should be at least 6 characters'),
                      ])
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: 'Forget password?',
                        style: const TextStyle(color: Colors.blue,
                            fontSize: 16),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ResetPassword()),
                            );
                          },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  AppButton(
                      text: 'Sign in',
                      textSize: 18,
                      onPressed: () async {
                        if (formKey.currentState!.saveAndValidate()) {
                          String ?token = await FirebaseMessaging.instance
                              .getToken();
                          var res = await AuthProv.signInWithEmail(formKey
                              .currentState!.value['email'],
                              formKey.currentState!.value['password'], context);

                          if (res is UserCredential) {
                            await UserPreferences.storeValue(
                                'UID', res.user!.uid);
                            final result = await FirebaseFirestore.instance
                                .collection('barbers').get();

                            for (var data in result.docs) {
                              if (data.id == res.user!.uid) {
                                if (data.data()['barberStatus'] == 1) {
                                  FirebaseFirestore.instance.collection(
                                      'barbers').doc(res.user!.uid).update({
                                    'token': token
                                  });
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                        builder: (context) => PhoneNoPage(),));
                                  return;
                                }
                                if (data.data()['barberStatus'] == 2) {
                                  FirebaseFirestore.instance.collection(
                                      'barbers').doc(res.user!.uid).update({
                                    'token': token
                                  });
                                  Position location = await AuthProv
                                      .getBarberLocation();

                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) =>
                                          MapPage(latitude: location.latitude,
                                              longitude:location.longitude),));
                                  return;
                                }
                                if (data.data()['barberStatus'] == 3) {
                                  FirebaseFirestore.instance.collection(
                                      'barbers').doc(res.user!.uid).update({
                                    'token': token
                                  });
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) =>
                                          PickPdfFilePage(res.user!.uid),));
                                  return;
                                }
                                if (data.data()['barberStatus'] == 4) {
                                  FirebaseFirestore.instance.collection(
                                      'barbers').doc(res.user!.uid).update({
                                    'token': token
                                  });
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) =>
                                          WaitingAdminPage(),));
                                  return;
                                }
                                if (data.data()['barberStatus'] == 5) {
                                  FirebaseFirestore.instance.collection(
                                      'barbers').doc(res.user!.uid).update({
                                    'token': token
                                  });
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) =>
                                          BarberHomePage(),));
                                  return;
                                }
                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text(
                                          'your profession certificate request rejected')));

                                  return;
                                }
                              }
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('${res.user?.email}')));


                            FirebaseFirestore.instance.collection('users').doc(
                                res.user!.uid).update({
                              'token': token
                            });
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HomePage(),));
                          }
                          else if (res != -1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('please verify your email')));
                          }
                        }
                      }),

                  SizedBox(
                    height: 1.h,
                  ),

                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      SizedBox(
                        width: 5.w,
                      ),
                      AppText(
                        text: 'OR',
                        color: Colors.black54,
                        size: 18,
                        bold: FontWeight.w300,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  AppButton(
                      text: 'Sign up',
                      textSize: 18,
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ));
                      }),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
