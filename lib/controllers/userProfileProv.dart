import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hair_and_more/models/user.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileProv with ChangeNotifier {
  var formKey = GlobalKey<FormBuilderState>();
  late UserModel user;
  bool isLoading = true;
  bool? isFirebaseImage =false;
  bool edit = false;
  File? image;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String? imageUrl;

  UserProfileProv() {
    fetchUserData();
  }

  fetchUserData() async {
    user = await UserModel.fetchUserData();
    imageUrl = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) => value.data()!['image']);

    if (imageUrl == '') {
      isFirebaseImage = false;
    } else {
      isFirebaseImage = true;
    }

    isLoading = false;
    notifyListeners();
  }

  editProfile(bool edit) {
    this.edit = edit;
    notifyListeners();
    print(edit);
  }
  saveFirstLastName(BuildContext context)
  async {
    var message = ScaffoldMessenger.of(context);
    if(formKey.currentState!.saveAndValidate())
      {
        var data =formKey.currentState!.value;
        print(data['firstName']);
        print(data['lastName']);
       await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'firstName': data['firstName'],
          'lastName':  data['lastName'],
        });
        edit = false;
      message.showSnackBar(const SnackBar(content: Text('updated successfully')));
      }

    notifyListeners();
  }


  addProfilePicture(ImageSource source, BuildContext context) async {
    try {
      var img = await ImagePicker().pickImage(source: source);
      if (img == null) return;

      image = File(img.path);
      final path = 'usersImages/$userId';
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(File(image!.path));

      imageUrl = await FirebaseStorage.instance
          .ref('usersImages/$userId')
          .getDownloadURL();
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'image': imageUrl});
      notifyListeners();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Navigator.of(context).pop();
    }
  }

  showModelBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          color: Colors.white70,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        addProfilePicture(ImageSource.gallery, context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.image_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Browse gallery',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )
                        ],
                      )),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Divider(
                      thickness: 1,
                    ),
                    Text('OR'),
                    Divider(
                      height: 10,
                      color: Colors.red,
                      thickness: 1,
                    )
                  ],
                ),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                      onPressed: () {
                        addProfilePicture(ImageSource.camera, context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Use a camera',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
