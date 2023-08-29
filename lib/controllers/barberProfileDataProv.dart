import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hair_and_more/controllers/bookingProv.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/barber.dart';
import '../models/barberReviews.dart';
import '../models/offer.dart';
import '../models/product.dart';
import '../models/service.dart';

class BarberProfileDataProv with ChangeNotifier {
  bool isLoading = true;
  List<Product> products = [];
  List<Offer> offers = [];
  List<Service> services = [];
  List<BarberReviews> barberReviews = [];
  File? image;
  String? imageUrl;
  bool? isFirebaseImage = false;
  Barber? barber;
  double barberRating = 1;

  BarberProfileDataProv(String id) {
    fetchBarberData(id);
    fetchBarberProducts(id);
    fetchBarberOffers(id);
    fetchBarberServices(id);
  }

  fetchBarberData(String id) async {
    barber = await Barber.fetchBarberData(id);

    imageUrl = await FirebaseFirestore.instance
        .collection('barbers')
        .doc(id)
        .get()
        .then((value) => value.data()?['image']);
    notifyListeners();
    if (imageUrl == '') {
      print(id);
      print(id);
      isFirebaseImage = false;
    } else {
      isFirebaseImage = true;
    }
  }

  fetchBarberProducts(String id) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(id)
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

  fetchBarberOffers(String id) async {
    await FirebaseFirestore.instance
        .collection('offers')
        .doc(id)
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

  fetchBarberServices(String id) async {
    await FirebaseFirestore.instance
        .collection('services')
        .doc(id)
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

  setRating(double rating) {
    barberRating = rating;
    notifyListeners();
    print(barberRating);
  }

  rateBarber(Barber barber) async {
    double ratingAvg = 0.0;
    print(barberRating);
    var reviews;
    print(barber?.uid);
    await FirebaseFirestore.instance
        .collection('barbers')
        .doc(barber?.uid)
        .get()
        .then((value) {
      reviews = value.data()?['reviews'];
      notifyListeners();
    });
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var ratingsCollection = FirebaseFirestore.instance
        .collection('barbers')
        .doc(barber?.uid)
        .collection('barberReviews')
        .doc('ratings');
    ratingsCollection.get().then((value) async {
      BarberReviews barberRate =
          BarberReviews(userId: userId, rating: barberRating);
      if (value.data()?['ratings'] == null) {
        barberReviews.add(barberRate);

        await ratingsCollection
            .set({'ratings': barberReviews.map((e) => e.toJson()).toList()});

        notifyListeners();
        for(int i = 0; i<barberReviews.length;i++) {
          ratingAvg = ratingAvg + barberReviews[i].rating;
        }
        await FirebaseFirestore.instance
            .collection('barbers')
            .doc(barber?.uid)
            .update({'rating': ratingAvg/barberReviews.length});
        await FirebaseFirestore.instance
            .collection('barbers')
            .doc(barber?.uid)
            .update({'reviews': reviews + 1});
      } else {
        barberReviews = List.of(value.data()?['ratings'])
            .map((e) => BarberReviews.fromJson(e as Map<String, dynamic>))
            .toList();
        for(int i = 0; i<barberReviews.length;i++) {
          if(barberReviews[i].userId == userId)
            {
              barberReviews[i].rating = barberRating;
              notifyListeners();
              ratingsCollection.update({
                'ratings': barberReviews.map((e) => e.toJson()).toList()
              });
              for(int i = 0; i<barberReviews.length;i++) {
                ratingAvg = ratingAvg + barberReviews[i].rating;
              }
              await FirebaseFirestore.instance
                  .collection('barbers')
                  .doc(barber?.uid)
                  .update({'rating': ratingAvg/barberReviews.length});
             return;
            }
        };
        barberReviews.add(barberRate);
        await ratingsCollection
            .set({'ratings': barberReviews.map((e) => e.toJson()).toList()});
        await FirebaseFirestore.instance
            .collection('barbers')
            .doc(barber?.uid)
            .update({'reviews': reviews + 1});
        for(int i = 0; i<barberReviews.length;i++) {
          ratingAvg = ratingAvg + barberReviews[i].rating;
        }
        await FirebaseFirestore.instance
            .collection('barbers')
            .doc(barber?.uid)
            .update({'rating': ratingAvg/barberReviews.length});
        await Barber.fetchBarberData(barber.uid);
        notifyListeners();
      }
    });
  }

  Future<void> openLocation(double latitude,double longitude) async {
    print(latitude);
     String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
     await launchUrl(Uri.parse(googleUrl));
  }
}
