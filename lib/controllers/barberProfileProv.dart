import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/barber.dart';
import '../models/offer.dart';
import '../models/product.dart';
import '../models/service.dart';

class BarberProfileProv with ChangeNotifier {
  String barberId = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;
  List<Product> products = [];
  List<Offer> offers = [];
  List<Service> services = [];
  File? image;
  String? imageUrl;
  bool? isFirebaseImage =false;
  Barber? barber;
  BarberProfileProv() {
    fetchBarberData();
    fetchBarberProducts();
    fetchBarberOffers();
    fetchBarberServices();
  }

  fetchBarberData() async {

    barber = await Barber.fetchBarberData(barberId);

    imageUrl = await FirebaseFirestore.instance
        .collection('barbers')
        .doc(barberId)
        .get()
        .then((value) => value.data()?['image']);

    if (imageUrl == '') {
      isFirebaseImage = false;
    } else {
      isFirebaseImage = true;
    }

    isLoading = false;
    notifyListeners();
  }
  fetchBarberProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(barberId)
        .get()
        .then((value) {
      return value.data()?['products'] == null
          ? []
          : {
        products = List.of(value.data()!['products'])
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList(),
      };
    });
    if (kDebugMode) {
      print(products.length);
    }

  }

  fetchBarberOffers() async {
    await FirebaseFirestore.instance
        .collection('offers')
        .doc(barberId)
        .get()
        .then((value) {
      return value.data()?['offers'] == null
          ? []
          : {
        offers = List.of(value.data()!['offers'])
            .map((e) => Offer.fromJson(e as Map<String, dynamic>))
            .toList(),
      };
    });
    print(products.length);
  }
  fetchBarberServices() async {
    await FirebaseFirestore.instance
        .collection('services')
        .doc(barberId)
        .get()
        .then((value) {
      return value.data()?['services'] == null
          ? []
          : {
        services = List.of(value.data()!['services'])
            .map((e) => Service.fromJson(e as Map<String, dynamic>))
            .toList(),
      };
    });
    print(services.length);
    isLoading = false;
    notifyListeners();
  }
  addProfilePicture(ImageSource source, BuildContext context) async {
    ScaffoldMessengerState message = ScaffoldMessenger.of(context);
    NavigatorState navigator = Navigator.of(context);
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            )),
      );
      var img = await ImagePicker().pickImage(source: source);
      if (img == null) return;

      image = File(img.path);
      final path = 'barbersImages/$barberId';
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(File(image!.path));

      imageUrl = await FirebaseStorage.instance
          .ref('barbersImages/$barberId')
          .getDownloadURL();
      FirebaseFirestore.instance
          .collection('barbers')
          .doc(barberId)
          .update({'image': imageUrl});
      notifyListeners();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Navigator.of(context).pop();
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