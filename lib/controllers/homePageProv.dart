import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/barber.dart';

class HomePageProv with ChangeNotifier {
  final userCollection = FirebaseFirestore.instance.collection('users');
  bool isLoading = true;
  List<Barber> barbers = [];
  List<Barber> filteredList = [];
  String? firstName;
  String? lastName;
  String? imageUrl;
  bool isSearch = false;
  bool isFirebaseImage = false;
  HomePageProv() {
    getBarbers();
    getUserData();
  }

   getBarbers() async {
    final result = await FirebaseFirestore.instance.collection('barbers').get();

    for (var data in result.docs) {
      barbers.add(Barber.fromJson(data.data()));
    }
    notifyListeners();
  }

  getUserData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      userCollection.doc(firebaseUser.uid).get().then((ds) {
        firstName = ds.data()?['firstName'];
        lastName = ds.data()?['lastName'];
        imageUrl = ds.data()?['image'];
        if (imageUrl == '') {
          isFirebaseImage = false;
        } else {
          isFirebaseImage = true;
        }
        isLoading = false;
        notifyListeners();
      }
      );
    }
  }

  barberSearch(String name){
    if(name == '')
      {
        isSearch = false;
        notifyListeners();
      }
    else
      {
        List<Barber> suggestions = barbers.where((element) {
          final barberFirstName = element.firstName.toLowerCase();
          final barberLastName = element.lastName.toLowerCase();
          final input = name.toLowerCase();
          return barberFirstName.contains(input) || barberLastName.contains(input);
        }).toList();
        filteredList = suggestions;
        isSearch = true;
        notifyListeners();
      }
  }
}
