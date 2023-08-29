import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String userID;
  DateTime startTime;
  DateTime endTime;
  int slotNo;
  String userFirstName;
  String userLastName;
  String service;
  String price;
  DateTime submitDate;
  String token;

  Appointment(
      {required this.userID,
      required this.startTime,
      required this.endTime,
      required this.userFirstName,
      required this.slotNo,
      required this.userLastName,
        required this.service,
        required this.submitDate,
      required this.token,
       required this.price
      });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    Timestamp startTime = json["startTime"];
    Timestamp endTime = json["endTime"];
    Timestamp submitDate = json["submitDate"];
    return Appointment(
        userID: json["userID"],
        startTime: startTime.toDate(),
        endTime: endTime.toDate(),
        userFirstName: json["userFirstName"],
        slotNo: json["slotNo"],
        userLastName: json["userLastName"],
        service: json["service"],
        submitDate: submitDate.toDate(),
        token: json["token"],
        price: json["price"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userID": userID,
      "startTime": startTime,
      "endTime": endTime,
      "userFirstName": userFirstName,
      "userLastName": userLastName,
      "slotNo": slotNo,
      'service':service,
      'submitDate':submitDate,
      "price":price.toString(),
      "token": token
    };
  }
}
