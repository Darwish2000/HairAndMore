import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String firstName;
  String lastName;
  String email;
  int gender;
  String token;
  String image;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.gender,
      required this.token,
      required this.image
      });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      gender: json["gender"],
      token: json['token'],
      image: json['image']
    );

  }

  static fetchUserData() async {
    UserModel user;
    var uid = FirebaseAuth.instance.currentUser?.uid;
    print(uid.toString());
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      if (data != null) {
        user = UserModel.fromJson(data!);
        return user;
      } else {
        print('error');
      }
    }
  }
}
