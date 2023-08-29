import 'package:hair_and_more/models/slot.dart';

const TIME_SLOT = [
  '9:00-10:00',
  '10:00-11:00',
  '11:00-12:00',
  '12:00-13:00',
  '13:00-14:00',
  '14:00-15:00',
  '15:00-16:00',
  '16:00-17:00',
  '17:00-18:00',
  '18:00-19:00',
  '19:00-20:00',
  '20:00-21:00',
  '21:00-22:00',
  '22:00-23:00',
  '23:00-00:00',
];
List<Map<String,String>> slots =
[
  {'9-10':"1"},
  {'slot':'9-10','availableFlag':'1'},
  {'slot':'9-10','availableFlag':'1'},
  {'slot':'9-10','availableFlag':'1'},
  {'slot':'9-10','availableFlag':'1'},
  {'slot':'9-10','availableFlag':'1'},
  {'slot':'9-10','availableFlag':'1'},
  {'slot':'9-10','availableFlag':'1'},
];

enum slotState{
  prev,
  current,
  future
}
Future getMaxAvailableTimeSlots(DateTime date) async{
  DateTime now = date.toUtc().add(Duration(hours: 3));

   print(now);

   List<DateTime> slots=[];

 var newList=  slots.where((element) => element.compareTo(now).isNegative==false);

    var res= date.compareTo(now);
    if(res.isNegative)
      return slotState.prev;
    if(res==0)
      return slotState.current;
    if (res>0)
      return slotState.future;

  if(now.isBefore(DateTime(now.year,now.month,now.day,9,0)))
    return 0;
   if(now.isAfter(DateTime(now.year,now.month,now.day,9,0)) && now.isBefore(DateTime(now.year,now.month,now.day,10,0)))
    return 1;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,10,0)) && now.isBefore(DateTime(now.year,now.month,now.day,11,0)))
    return 2;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,11,0)) && now.isBefore(DateTime(now.year,now.month,now.day,12,0)))
    return 3;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,12,0)) && now.isBefore(DateTime(now.year,now.month,now.day,13,0)))
    return 4;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,13,0)) && now.isBefore(DateTime(now.year,now.month,now.day,14,0)))
    return 5;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,14,0)) && now.isBefore(DateTime(now.year,now.month,now.day,15,0)))
    return 6;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,15,0)) && now.isBefore(DateTime(now.year,now.month,now.day,16,0)))
    return 7;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,16,0)) && now.isBefore(DateTime(now.year,now.month,now.day,17,0)))
    return 8;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,5,0)) && now.isBefore(DateTime(now.year,now.month,now.day,6,0)))
    return 9;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,18,0)) && now.isBefore(DateTime(now.year,now.month,now.day,19,0)))
    return 10;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,19,0)) && now.isBefore(DateTime(now.year,now.month,now.day,20,0)))
    return 11;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,20,0)) && now.isBefore(DateTime(now.year,now.month,now.day,21,0)))
    return 12;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,21,0)) && now.isBefore(DateTime(now.year,now.month,now.day,22,0)))
    return 13;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,22,0)) && now.isBefore(DateTime(now.year,now.month,now.day,23,0)))
    return 14;
  else if(now.isAfter(DateTime(now.year,now.month,now.day,23,0)) && now.isBefore(DateTime(now.year,now.month,now.day,00,0)))
    return 15;
  else
    return 16;
}