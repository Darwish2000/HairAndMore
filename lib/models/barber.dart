import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hair_and_more/models/slot.dart';

class Barber {
  String uid;
  String email;
  String firstName;
  String lastName;
  int gender;
  int reviews;
  double rating;
  int barberStatus;
  String image;
  String phoneNo;
  String token;
  double latitude;
  double longitude;
  List<Slot> slots;

  Barber(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.reviews,
      required this.rating,
      required this.email,
      required this.barberStatus,
      required this.image,
        required this.phoneNo,
        required this.latitude,
        required this.longitude,
      required this.token,
      required this.slots});

  factory Barber.fromJson(Map<String, dynamic> json) {
    print('hello');
    return Barber(
      uid: json["uid"],
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      gender: json["gender"],
      reviews: json["reviews"],
      rating: 0.0 + json["rating"],
      barberStatus: json['barberStatus'],
      image: json['image'],
      phoneNo: json['phoneNo'],
      latitude:0.0 + json['latitude'],
      longitude:0.0 + json['longitude'] ,
      token: json['token'],
      slots: List.of(json["slots"] as List)
          .map((e) => Slot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "reviews": reviews,
      "rating": rating,
      'barberStatus': barberStatus,
      'image': image,
      'phoneNo':phoneNo,
      'latitude':latitude,
      'longitude':longitude,
      'token': token,
      "slots": slots.map((e) => e.toJson()).toList(),
    };
  }

  static fetchBarberData(String id) async {
    Barber barber;
    var uid = FirebaseAuth.instance.currentUser?.uid;
    print(uid.toString());
    var collection = FirebaseFirestore.instance.collection('barbers');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      if (data != null) {
        barber = Barber.fromJson(data!);
        return barber;
      } else {
        print('error');
      }
    }
  }
}
