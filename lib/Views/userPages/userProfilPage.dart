import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_and_more/widgets/appButton.dart';
import 'package:hair_and_more/widgets/formTextField.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controllers/userProfileProv.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
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
      body: ChangeNotifierProvider(
        create: (context) => UserProfileProv(),
        builder: (context, child) => Consumer<UserProfileProv>(
          builder: (context, prov, child) {
            return !prov.isLoading
                ? FormBuilder(
                    initialValue: {
                      'firstName': prov.user.firstName,
                      'lastName': prov.user.lastName,
                      'email': prov.user.email,
                    },
                    key: prov.formKey,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.h, horizontal: 4.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 200,
                              height: 150,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: Center(
                                  child: !prov.isFirebaseImage!
                                      ? prov.image == null
                                          ? const CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              radius: 200,
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.black,
                                                size: 100,
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 200,
                                              backgroundImage:
                                                  FileImage(prov.image!),
                                            )
                                      : Container(
                                      width: 190.0,
                                      height: 190.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  prov.imageUrl!)
                                          )
                                      )),),
                            ),
                            TextButton(
                                onPressed: () {
                                  prov.showModelBottomSheet(context);
                                },
                                child: const Text(
                                  'Change profile picture',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.blueGrey),
                                )),
                            Row(
                              children: [
                                Expanded(
                                    child: FormTextField(
                                  text: 'First name',
                                  textSize: 18,
                                  name: 'firstName',
                                  enabled: prov.edit ? true : false,
                                )),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Expanded(
                                    child: FormTextField(
                                  text: 'Last name',
                                  textSize: 18,
                                  name: 'lastName',
                                  enabled: prov.edit ? true : false,
                                )),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            FormTextField(
                              text: 'Email',
                              name: 'email',
                              textSize: 18,
                              icon: const Icon(Icons.email_outlined),
                              enabled: false,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            // FormTextField(
                            //   text: 'Phone number',
                            //   textSize: 18,
                            //   name: 'phoneNumber',
                            //   icon: const Icon(Icons.phone_outlined),
                            //   enabled: false,
                            // ),
                            SizedBox(
                              height: 3.h,
                            ),
                            !prov.edit
                                ? AppButton(
                                    text: 'Edit',
                                    onPressed: () {
                                      prov.editProfile(true);
                                    })
                                : AppButton(text: 'Save', onPressed: () {
                                  prov.saveFirstLastName(context);
                            })
                          ],
                        ),
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
