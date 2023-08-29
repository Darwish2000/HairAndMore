import 'package:cloud_firestore/cloud_firestore.dart';

class Slot {
  final int id;
  int availableSlotFlag;
  DateTime startTime;
  DateTime endTime;

  Slot(
      {required this.id,
      required this.availableSlotFlag,
      required this.startTime,
      required this.endTime});


  static setBarberSlots() {
    List<Slot> barberSlots = [
      Slot(
        id: 1,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 9, 0),
        endTime: DateTime(2022, 12, 12, 10, 0),
      ),
      Slot(
        id: 2,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 10, 0),
        endTime: DateTime(2022, 12, 12, 11, 0),
      ),
      Slot(
        id: 3,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 11, 0),
        endTime: DateTime(2022, 12, 12, 12, 0),
      ),
      Slot(
        id: 4,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 12, 0),
        endTime: DateTime(2022, 12, 12, 13, 0),
      ),
      Slot(
        id: 5,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 13, 0),
        endTime: DateTime(2022, 12, 12, 14, 0),
      ),
      Slot(
        id: 6,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 14, 0),
        endTime: DateTime(2022, 12, 12, 15, 0),
      ),
      Slot(
        id: 7,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 15, 0),
        endTime: DateTime(2022, 12, 12, 16, 0),
      ),
      Slot(
        id: 8,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 16, 0),
        endTime: DateTime(2022, 12, 12, 17, 0),
      ),
      Slot(
        id: 9,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 17, 0),
        endTime: DateTime(2022, 12, 12, 18, 0),
      ),
      Slot(
        id: 10,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 18, 0),
        endTime: DateTime(2022, 12, 12, 19, 0),
      ),
      Slot(
        id: 11,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 19, 0),
        endTime: DateTime(2022, 12, 12, 20, 0),
      ),
      Slot(
        id: 12,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 20, 0),
        endTime: DateTime(2022, 12, 12, 21, 0),
      ),
      Slot(
        id: 13,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 21, 0),
        endTime: DateTime(2022, 12, 12, 22, 0),
      ),
      Slot(
        id: 14,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 22, 0),
        endTime: DateTime(2022, 12, 12, 23, 0),
      ),
      Slot(
        id: 15,
        availableSlotFlag: 1,
        startTime: DateTime(2022, 12, 12, 23, 0),
        endTime: DateTime(2022, 12, 12, 00, 0),
      ),
    ];
    return barberSlots;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "availableSlotFlag": availableSlotFlag,
      "startTime": startTime,
      "endTime": endTime,
    };
  }

  factory Slot.fromJson(Map<String, dynamic> json) {

    Timestamp start = json["startTime"];
    Timestamp end = json["endTime"];

    return Slot(
      id: json['id'],
      availableSlotFlag: json["availableSlotFlag"],
      startTime: DateTime.parse(start.toDate().toString()),
      endTime: DateTime.parse(end.toDate().toString()),
    );
  }
//

}
