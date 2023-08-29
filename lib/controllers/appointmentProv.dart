import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:hair_and_more/models/userAppointment.dart';
import 'package:hair_and_more/utils/pushNotification.dart';
import '../models/appointment.dart';
import '../models/barber.dart';

class AppointmentProv with ChangeNotifier {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  List<Appointment> appointments = [];
  List<UserAppointment> userAppointments = [];
  AdvancedDrawerController advancedDrawerController =
      AdvancedDrawerController();
  bool isLoading = true;
  Barber? barber;

  AppointmentProv() {
    getUserAppointment();
    getAppointments();
    listenToNewAppointment();
    requestPermission();
    fetchBarberData();
  }

  fetchBarberData() async {
    barber = await Barber.fetchBarberData(firebaseUser!.uid);
    isLoading = false;
    notifyListeners();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
  }

  getAppointments() async {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(firebaseUser!.uid)
        .get()
        .then((value) {
      if (value.data()?['appointments'] != null) {
        appointments = List.of(value.data()!['appointments'])
            .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
            .toList();
        print('--------------------------------');
        // isLoading = false;
        notifyListeners();
      } else {
        appointments = [];
        // isLoading = false;
        notifyListeners();
      }
    });
  }

  listenToNewAppointment() async {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(firebaseUser!.uid)
        .snapshots()
        .listen((event) async {
      if (event.data()?['appointments'] != null &&
          event.data()?['appointments'].length != appointments.length) {
        List<dynamic> appoints = event['appointments'];
        appointments.add(Appointment.fromJson(appoints.last));
        notifyListeners();
      }
    });
  }

  acceptAppointment(Appointment appointment, BuildContext context) async {
    ScaffoldMessengerState message = ScaffoldMessenger.of(context);

    var docRef =
        FirebaseFirestore.instance.collection('barbers').doc(firebaseUser!.uid);

    docRef.get().then((currentBarberObj) async {
      List<dynamic> slots = currentBarberObj['slots'];
      var slotObj = slots[appointment.slotNo!];
      slotObj['availableSlotFlag'] = slotObj['availableSlotFlag'] == 0 ? 1 : 0;
      slots[appointment.slotNo!] = slotObj;
      await docRef.update({'slots': slots});
      if (kDebugMode) {
        print("update done");
      }
      notifyListeners();
    });

    List<UserAppointment> userAppointments = [];
    var doc = FirebaseFirestore.instance
        .collection('users')
        .doc(appointment.userID)
        .collection('userAppointments')
        .doc('appointments');
    UserAppointment userAppointment = UserAppointment(
      barberLastName: barber!.firstName,
        barberFirstName: barber!.lastName,
        barberId: firebaseUser!.uid,
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        timeAccept: DateTime.now(),
        service: appointment.service,
        price: appointment.price);

    await doc.get().then((value) async {
      if (value.data()?['appointments'] == null) {
        userAppointments.add(userAppointment);
      } else {
        userAppointments = List.of(value.data()!['appointments'])
            .map((e) => UserAppointment.fromJson(e as Map<String, dynamic>))
            .toList();
        userAppointments.add(userAppointment);
      }

      await doc.set(
          {'appointments': userAppointments.map((e) => e.toJson()).toList()});
    });

    var removeDoc = FirebaseFirestore.instance
        .collection('appointments')
        .doc(firebaseUser!.uid);
    removeDoc.get().then((value) async {
      appointments
          .removeWhere((element) => element.userID == appointment.userID);
      await removeDoc.update(
          {'appointments': appointments.map((e) => e.toJson()).toList()});
      message
          .showSnackBar(const SnackBar(content: Text('Reservation accepted')));
      notifyListeners();
      pushMessage(
          'Your appointment has been confirmed by ${barber!.firstName} ${barber!.lastName}; don\'t be late',
          appointment.token);
    });
  }

  rejectAppointment(Appointment appointment, BuildContext context) {
    ScaffoldMessengerState message = ScaffoldMessenger.of(context);


    var docRef = FirebaseFirestore.instance
        .collection('appointments')
        .doc(firebaseUser!.uid);
    docRef.get().then((value) {
      appointments
          .removeWhere((element) => element.userID == appointment.userID);
      message
          .showSnackBar(const SnackBar(content: Text('Reservation Rejected')));
      notifyListeners();
      pushMessage(
          'Your appointment has been canceled by ${barber!.firstName} ${barber!
              .lastName}',
          appointment.token);
    });
  }

  showDrawer() {
    advancedDrawerController.showDrawer();
    notifyListeners();
  }

  getUserAppointment() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var doc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('userAppointments')
        .doc('appointments')
        .get()
        .then((value) {
      if (value.data()?['appointments'] != null) {
        userAppointments = List.of(value.data()?['appointments'])
            .map((e) => UserAppointment.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      notifyListeners();
    });
  }
}
