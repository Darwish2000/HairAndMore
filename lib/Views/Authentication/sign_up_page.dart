import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hair_and_more/Views/Authentication/sign_in_page.dart';
import 'package:hair_and_more/controllers/authProv.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widgets/appButton.dart';
import '../../widgets/appText.dart';
import '../../widgets/formTextField.dart';

class SignUpPage extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();
  SignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: FormBuilder(
            key: formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
              child: Column(
                children: [
                  AppText(text: 'Sign up', color: Colors.black, bold: FontWeight.bold),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormTextField(
                          text: 'First Name',
                          textSize: 17,
                          icon: const Icon(Icons.person_outline_rounded),
                          name: 'firstName',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: 'Enter first Name'
                              ),
                              FormBuilderValidators.maxLength(20,errorText: '20 characters maximum'),
                            ])

                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: FormTextField(
                          text: 'lastName',
                          textSize: 17,
                          icon: const Icon(Icons.person_outline_rounded),
                          name: 'lastName',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: 'Enter last Name'
                              ),
                              FormBuilderValidators.maxLength(20,errorText: '20 characters maximum'),
                            ])

                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  FormTextField(
                    text: 'Email',
                    textSize: 17,
                    icon: const Icon(Icons.email_outlined),
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
                    height: 2.h,
                  ),
                  FormTextField(
                    isSecure: true,
                    text: 'Password',
                    textSize: 17,
                    icon: const Icon(Icons.password_outlined),
                    name: 'password',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Password required'
                      ),
                      FormBuilderValidators.minLength(6,errorText: 'The password should be at least 6 characters'),
                    ])
                  ),
                  
                  SizedBox(
                    height: 2.h,
                  ),

                  FormTextField(
                      isSecure: true,
                      text: 'confirm Password',
                      textSize: 17,
                      icon: const Icon(Icons.password_outlined),
                      name: 'confirmPassword',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Password required'
                        ),
                        FormBuilderValidators.minLength(6,errorText: 'The password should be at least 6 characters'),
                      ])
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      AppText(
                        text: 'Gender',
                        size: 20,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Expanded(
                        child: FormBuilderChoiceChip<int>(
                          spacing: 15,
                          elevation: 5,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          selectedColor: Colors.blueGrey,
                          validator: FormBuilderValidators.required(
                              errorText: 'choose gender'),
                          name: 'gender',
                          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 1.5.w),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (d) {},
                          labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                          options: const [
                            FormBuilderChipOption(
                              value: 0,
                              child: Text(
                                "Male",
                              ),
                            ),
                            FormBuilderChipOption(
                              value: 1,
                              child: Text(
                                "Female",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      AppText(
                        text: 'Select',
                        size: 20,
                      ),
                      SizedBox(width: 8.w,),
                      Expanded(
                        child: FormBuilderChoiceChip<int>(
                          spacing: 15,
                          elevation: 5,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          selectedColor: Colors.blueGrey,
                          validator: FormBuilderValidators.required(
                              errorText: 'choose your type'),
                          name: 'type',
                          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 1.5.w),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (d) {},
                          labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                          options: const [
                            FormBuilderChipOption(
                              value: 0,
                              child: Text(
                                "Customer",
                              ),
                            ),
                            FormBuilderChipOption(
                              value: 1,
                              child: Text(
                                "Specialist",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 3.h,
                  ),

                  AppButton(
                      text: 'SIGN UP',
                      onPressed: () async {
                        if (formKey.currentState!.saveAndValidate()) {

                          var data = formKey.currentState!.value;
                          if(data['password'].toString().trim() == data['confirmPassword'].toString().trim())
                            {
                              var res = await AuthProv.signUpWithEmail(data,context);
                              if (res is UserCredential) {
                                await showDialog(context: context, builder: (context) =>  AlertDialog(content: const Text('verify your email'),
                                  actions: [
                                    TextButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, child: const Text('ok'))
                                  ],
                                ));
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SignInPage(),));
                              }
                              else
                                {
                                  print('no');
                                }
                            }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('password and confirm password don\'t match')));
                          }
                        }
                      }),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have account? '),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInPage()));
                        },
                        child: const Text(
                          'login',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue),
                        ),
                      )
                    ],
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
