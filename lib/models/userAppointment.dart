import 'package:cloud_firestore/cloud_firestore.dart';

class UserAppointment {
  String barberId;
  DateTime startTime;
  DateTime endTime;
  DateTime timeAccept;
  String service;
  String price;
  String barberFirstName;
  String barberLastName;

  UserAppointment(
      {required this.barberId,
      required this.startTime,
      required this.endTime,
      required this.timeAccept,
      required this.service,
      required this.price,
      required this.barberFirstName,
      required this.barberLastName});

  Map<String, dynamic> toJson() {
    return {
      "barberId": barberId,
      "startTime": startTime,
      "endTime": endTime,
      "price": price.toString(),
      "service": service,
      "timeAccept": timeAccept,
      "barberFirstName":barberFirstName,
      "barberLastName":barberLastName
    };
  }

  factory UserAppointment.fromJson(Map<String, dynamic> json) {
    Timestamp startTime = json["startTime"];
    Timestamp endTime = json["endTime"];
    Timestamp timeAccept = json["timeAccept"];
    return UserAppointment(
        barberId: json["barberId"],
        startTime: startTime.toDate(),
        endTime: endTime.toDate(),
        price: json['price'],
        service: json['service'],
        barberFirstName:json['barberFirstName'],
        barberLastName: json['barberLastName'],
        timeAccept: timeAccept.toDate());
  }
}

