import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hair_and_more/Views/Authentication/sign_in_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utils/auth.dart';
import '../../widgets/appButton.dart';
import '../../widgets/appText.dart';
import '../../widgets/formTextField.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Reset password',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FormBuilder(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 3.h,
                ),
                AppText(
                  text: 'Please enter your email address',
                  size: 19,
                ),
                AppText(
                  text: 'to request a password reset',
                  size: 19,
                ),
                SizedBox(
                  height: 3.h,
                ),
                FormTextField(
                    text: 'Email',
                    icon: const Icon(Icons.email_outlined),
                    name: 'email',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.email(
                          errorText: 'invalid email',),
                      FormBuilderValidators.required(
                          errorText: 'email required')
                    ])
                ),
                SizedBox(
                  height: 2.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: AppButton(
                    text: 'Reset password',
                    textSize: 19,
                    onPressed: () async {
                      if (formKey.currentState!.saveAndValidate()) {
                        final status =
                        await AuthenticationHelper.resetPassword(
                            formKey.currentState!.value['email']);
                        if (status == AuthStatus.successful) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text('Password Reset Email Sent')));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        } else {
                          final error =
                          AuthExceptionHandler.generateErrorMessage(
                              status);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(error)));
                        }
                      }
                    },
                    width: 15.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
