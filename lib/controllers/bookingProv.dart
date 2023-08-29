import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hair_and_more/models/appointment.dart';
import 'package:hair_and_more/models/user.dart';
import 'package:hair_and_more/utils/pushNotification.dart';
import '../models/barber.dart';
import '../models/service.dart';
import '../models/slot.dart';

class BookingProv extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  bool isSelected = false;
  int? index = -1;
  DateTime? startTime;
  DateTime? endTime;
  int? selectedSlot;
  Barber barber;
  int? maxTimeSlots;
  int? selectedIndex;
  Service? submitService;
  List<Appointment> appointments = [];
  List<dynamic> newSlots = [];
  final userCollection = FirebaseFirestore.instance.collection('users');
  bool isLoading = false;

  BookingProv(this.barber) {
    requestPermission();
    getMaxAvailableTimeSlots();
    listenToChanges();
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
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  getMaxAvailableTimeSlots() async {
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 2));
    print('time now :   $now');
    maxTimeSlots =
        newSlots.where((element) => element.endTime.hour <= now.hour).length;
    maxTimeSlots = maxTimeSlots! + 1!;
    notifyListeners();
    print(maxTimeSlots);
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  listenToChanges() async {
    FirebaseFirestore.instance
        .collection('barbers')
        .doc(barber.uid)
        .snapshots()
        .listen((event) {
      print("got new event for this barber ${event.data()}");
      newSlots = List.of(event.data()!['slots'] as List)
          .map((e) => Slot.fromJson(e as Map<String, dynamic>))
          .toList();
      getMaxAvailableTimeSlots();
      notifyListeners();
    });
  }

  void selectedTime(DateTime startTime, DateTime endTime, int index) {
    selectedIndex = index;
    this.startTime = startTime;
    this.endTime = endTime;
    selectedSlot = index;
    isSelected = true;
    notifyListeners();
    print(startTime);
    print(endTime);
  }

  updateAvailableSlotFlag() async {
    var docRef =
        FirebaseFirestore.instance.collection('barbers').doc(barber.uid);

    docRef.get().then((currentBarberObj) async {
      List<dynamic> slots = currentBarberObj['slots'];
      if (selectedIndex == null) {
        print("null selected index");
        return null;
      }
      var slotObj = slots[selectedIndex!];
      slotObj['availableSlotFlag'] = slotObj['availableSlotFlag'] == 0 ? 1 : 0;
      slots[selectedIndex!] = slotObj;

      await docRef.update({'slots': slots});
      print("update done");
    });
  }

  sendAppointmentToBarber() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    UserModel? user;
    if (firebaseUser != null) {
      await userCollection.doc(firebaseUser.uid).get().then((value) async {
        user = UserModel.fromJson(value.data()!);

        if (kDebugMode) {
          print(user!.firstName.toString());
        }
      });
      Appointment appointment = Appointment(
          token: user!.token,
          startTime: startTime!,
          endTime: endTime!,
          slotNo: selectedSlot!,
          userFirstName: user!.firstName,
          userLastName: user!.lastName,
          submitDate: DateTime.now(),
          service: submitService!.serviceDescription,
          price: submitService!.price.toString(),
          userID: firebaseUser.uid);

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(barber.uid)
          .get()
          .then((value) {
        return value.data()?['appointments'] == null
            ? appointments.add(appointment)
            : {
                appointments = List.of(value.data()!['appointments'])
                    .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
                    .toList(),
                appointments.add(appointment)
              };
      });

      if (kDebugMode) {
        print('product length flutter ${appointments.length}');
      }
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(barber.uid)
          .set({
        'appointments': appointments.map((e) => e.toJson()).toList(),
      });
    }
    await pushMessage(
        'New reservation from ${user!.firstName} ${user!.lastName}',
        barber!.token);
    notifyListeners();
  }

  void selectService(Service service) {
    submitService = service;
    print(submitService!.serviceDescription);
    notifyListeners();
  }
}
