import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hair_and_more/models/offer.dart';
import 'package:hair_and_more/models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/service.dart';

class ProfileSettingsProv with ChangeNotifier {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  var formKeyProduct = GlobalKey<FormBuilderState>();
  var formKeyOffer = GlobalKey<FormBuilderState>();
  var formKeyService = GlobalKey<FormBuilderState>();
  bool? isFirebaseImage;
  bool isLoading = true;
  File? image;
  String? imageUrl;
  List<Product> products = [];
  List<Offer> offers = [];
  List<Service> services = [];
  int? id;

  ProfileSettingsProv() {
    fetchBarberProducts();
    fetchBarberOffers();
    fetchBarberServices();
  }

  fetchBarberProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(userId)
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
    isLoading = false;
    notifyListeners();
  }

  fetchBarberOffers() async {
    await FirebaseFirestore.instance
        .collection('offers')
        .doc(userId)
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
    isLoading = false;
    notifyListeners();
  }
  fetchBarberServices() async {
    await FirebaseFirestore.instance
        .collection('services')
        .doc(userId)
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

  addProductImage(ImageSource source, BuildContext context) async {
    try {
      var img = await ImagePicker().pickImage(source: source);
      if (img == null) return;

      image = File(img.path);
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
                        addProductImage(ImageSource.gallery, context);
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
                        addProductImage(ImageSource.camera, context);
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

  addProduct(BuildContext context) async {
    ScaffoldMessengerState message = ScaffoldMessenger.of(context);
    NavigatorState navigator = Navigator.of(context);
    if (formKeyProduct.currentState!.saveAndValidate()) {
      if (image != null) {
        showDialog(
          context: context,
          builder: (context) => const Center(
              child: CircularProgressIndicator(
            color: Colors.black,
          )),
        );
        String uid = const Uuid().v1();
        final path = 'productsImages/$uid';
        final ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(File(image!.path));
        imageUrl = await FirebaseStorage.instance
            .ref('productsImages/$uid')
            .getDownloadURL();
        Product product = Product(
            productId: uid,
            productImage: imageUrl!,
            price: double.parse(formKeyProduct.currentState!.value['price']),
            productDescription:
                formKeyProduct.currentState!.value['description']);

        await FirebaseFirestore.instance
            .collection('products')
            .doc(userId)
            .get()
            .then((value) {
          return value.data()?['products'] == null
              ? products.add(product)
              : {
                  products = List.of(value.data()!['products'])
                      .map((e) => Product.fromJson(e as Map<String, dynamic>))
                      .toList(),
                  products.add(product)
                };
        });
        if (kDebugMode) {
          print('product length flutter ${products.length}');
        }
        await FirebaseFirestore.instance
            .collection('products')
            .doc(userId)
            .set({
          'products': products.map((e) => e.toJson()).toList(),
        });
        products = [];
        image = null;
        fetchBarberProducts();
        notifyListeners();
        message.showSnackBar(
            const SnackBar(content: Text('Product added successfully')));
        navigator.pop();
        navigator.pop();
      } else {
        message.showSnackBar(
            const SnackBar(content: Text('please add image to your product')));
      }
    }
  }

  editProduct(BuildContext context, Product product) async {
    ScaffoldMessengerState message = ScaffoldMessenger.of(context);
    NavigatorState navigator = Navigator.of(context);
    showDialog(
      context: context,
      builder: (context) => const Center(
          child: CircularProgressIndicator(
        color: Colors.black,
      )),
    );
    try {
      if (formKeyProduct.currentState!.saveAndValidate()) {
        if (image == null) {
          imageUrl = product.productImage;
        } else {
          final path = 'productsImages/${product.productId}';
          final ref = FirebaseStorage.instance.ref().child(path);
          await ref.putFile(File(image!.path));
          imageUrl = await FirebaseStorage.instance
              .ref('productsImages/${product.productId}')
              .getDownloadURL();
        }
        var doc = FirebaseFirestore.instance.collection('products').doc(userId);

        doc.get().then((data) async {
          List<dynamic> prods = data['products'];
          int prodIndex = prods.indexWhere(
              (element) => element['productId'] == product.productId);
          Product prod = Product(
              productId: product.productId,
              productImage: imageUrl!,
              price: double.parse(formKeyProduct.currentState!.value['price']),
              productDescription:
                  formKeyProduct.currentState!.value['description']);
          products[prodIndex] = prod;
          if (kDebugMode) {
            print(products[prodIndex].productId);
          }
          await doc.update({
            'products': products.map((e) => e.toJson()).toList(),
          });
          notifyListeners();
        });
        message.showSnackBar(
            const SnackBar(content: Text('Successfully updated')));
        await fetchBarberProducts();
        notifyListeners();
        navigator.pop();
        navigator.pop();
      }
    } catch (e) {
      if (kDebugMode) {
        // print(e);
      }
    }
  }

  removeProduct(Product product, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
          child: CircularProgressIndicator(
        color: Colors.black,
      )),
    );
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState message = ScaffoldMessenger.of(context);
    products.removeWhere((element) => element.productId == product.productId);
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('products')
        .doc(userId)
        .update({'products': products.map((e) => e.toJson()).toList()});
    final path = 'productsImages/${product.productId}';
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.delete();
// Delete the file
    navigator.pop();
    message.showSnackBar(const SnackBar(content: Text('Product removed')));
  }

  addOffer(BuildContext context) async {
    ScaffoldMessengerState message = ScaffoldMessenger.of(context);
    NavigatorState navigator = Navigator.of(context);
    if (formKeyOffer.currentState!.saveAndValidate()) {
      showDialog(
        context: context,
        builder: (context) => const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        )),
      );
      String uid = const Uuid().v1();
      Offer offer = Offer(
          offerID: uid,
          description: formKeyOffer.currentState!.value['description']);

      await FirebaseFirestore.instance
          .collection('offers')
          .doc(userId)
          .get()
          .then((value) {
        return value.data()?['offers'] == null
            ? offers.add(offer)
            : {
                offers = List.of(value.data()!['offers'])
                    .map((e) => Offer.fromJson(e as Map<String, dynamic>))
                    .toList(),
                offers.add(offer)
              };
      });
      if (kDebugMode) {
        print('offers length flutter ${offers.length}');
      }
      await FirebaseFirestore.instance.collection('offers').doc(userId).set({
        'offers': offers.map((e) => e.toJson()).toList(),
      });
      offers = [];
      fetchBarberOffers();
      notifyListeners();
      message.showSnackBar(
          const SnackBar(content: Text('Offer added successfully')));
      navigator.pop();
      navigator.pop();
    }
  }

  editOffer(BuildContext context, Offer offer) async {
    if (formKeyOffer.currentState!.saveAndValidate()) {
      ScaffoldMessengerState message = ScaffoldMessenger.of(context);
      NavigatorState navigator = Navigator.of(context);
      showDialog(
        context: context,
        builder: (context) => const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        )),
      );
      var doc = FirebaseFirestore.instance.collection('offers').doc(userId);

      doc.get().then((data) async {
        List<dynamic> offersObj = data['offers'];
        int offerIndex = offersObj
            .indexWhere((element) => element['offerID'] == offer.offerID);

        Offer offerObj = Offer(
            offerID: offer.offerID,
            description: formKeyOffer.currentState!.value['description']);
        offers[offerIndex] = offerObj;
        if (kDebugMode) {
          print(offers[offerIndex].offerID);
        }
        await doc.update({
          'offers': offers.map((e) => e.toJson()).toList(),
        });
        notifyListeners();
      });

      await fetchBarberOffers();
      message
          .showSnackBar(const SnackBar(content: Text('Successfully updated')));
      notifyListeners();
      navigator.pop();
      navigator.pop();
    }
  }

  removeOffer(Offer offer, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
          child: CircularProgressIndicator(
        color: Colors.black,
      )),
    );
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState message = ScaffoldMessenger.of(context);
    offers.removeWhere((element) => element.offerID == offer.offerID);
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('offers')
        .doc(userId)
        .update({'offers': offers.map((e) => e.toJson()).toList()});
    navigator.pop();
    message.showSnackBar(const SnackBar(content: Text('Offer removed')));
  }

  addService(BuildContext context) async {

    ScaffoldMessengerState message = ScaffoldMessenger.of(context);
    NavigatorState navigator = Navigator.of(context);
    if (formKeyService.currentState!.saveAndValidate()) {
      showDialog(
        context: context,
        builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            )),
      );
      String uid = const Uuid().v1();
      Service service = Service(price:double.parse(formKeyService.currentState!.value['price']) , serviceId: uid, serviceDescription: formKeyService.currentState!.value['description']);
      await FirebaseFirestore.instance
          .collection('services')
          .doc(userId)
          .get()
          .then((value) {
        return value.data()?['services'] == null
            ? services.add(service)
            : {
          services = List.of(value.data()!['services'])
              .map((e) => Service.fromJson(e as Map<String, dynamic>))
              .toList(),
          services.add(service)
        };
      });
      if (kDebugMode) {
        print('services length flutter ${services.length}');
      }
      await FirebaseFirestore.instance.collection('services').doc(userId).set({
        'services': services.map((e) => e.toJson()).toList(),
      });
      services = [];
      fetchBarberServices();
      notifyListeners();
      message.showSnackBar(
          const SnackBar(content: Text('Service added successfully')));
      navigator.pop();
      navigator.pop();
    }

  }

  editService(BuildContext context, Service service) async {
    if (formKeyService.currentState!.saveAndValidate()) {
      ScaffoldMessengerState message = ScaffoldMessenger.of(context);
      NavigatorState navigator = Navigator.of(context);
      showDialog(
        context: context,
        builder: (context) => const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        )),
      );
      var doc = FirebaseFirestore.instance.collection('services').doc(userId);

      doc.get().then((data) async {
        List<dynamic> servicesObj = data['services'];
        int serviceIndex = servicesObj
            .indexWhere((element) => element['serviceId'] == service.serviceId);

        Service serviceObj = Service(
            price: double.parse(formKeyService.currentState!.value['price']),
            serviceId: service.serviceId,
            serviceDescription:
                formKeyService.currentState!.value['description']);
        services[serviceIndex] = serviceObj;
        if (kDebugMode) {
          print(services[serviceIndex].serviceId);
        }
        await doc.update({
          'services': services.map((e) => e.toJson()).toList(),
        });
        notifyListeners();
      });

      fetchBarberServices();
      message
          .showSnackBar(const SnackBar(content: Text('Successfully updated')));
      notifyListeners();
      navigator.pop();
      navigator.pop();
    }
  }

  removeService(BuildContext context, Service service) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
          child: CircularProgressIndicator(
        color: Colors.black,
      )),
    );
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState message = ScaffoldMessenger.of(context);
    services.removeWhere((element) => element.serviceId == service.serviceId);
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('services')
        .doc(userId)
        .update({'services': services.map((e) => e.toJson()).toList()});
    await fetchBarberServices();
    navigator.pop();
    message.showSnackBar(const SnackBar(content: Text('service removed')));
  }
}

