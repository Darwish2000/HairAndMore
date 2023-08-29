import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_and_more/Views/userPages/homePage.dart';
import 'package:hair_and_more/controllers/bookingProv.dart';
import 'package:hair_and_more/models/barber.dart';
import 'package:hair_and_more/models/service.dart';
import 'package:hair_and_more/widgets/appButton.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/product.dart';
import '../../widgets/submitDialog.dart';

class TimeSlotsPage extends StatelessWidget {
  Barber barber;
  List<Service> services;

  TimeSlotsPage(this.barber, this.services, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingProv(barber),
      builder: (context, child) => Consumer<BookingProv>(
        builder: (context, prov, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Booking',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                color: Colors.black,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.blueGrey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                DateFormat.MMMM().format(prov.selectedDate),
                                style:
                                    GoogleFonts.robotoMono(color: Colors.white),
                              ),
                              Text(
                                '${prov.selectedDate.day}',
                                style: GoogleFonts.robotoMono(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                              Text(
                                DateFormat.EEEE().format(prov.selectedDate),
                                style:
                                    GoogleFonts.robotoMono(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: prov.newSlots.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: prov.maxTimeSlots! <= index &&
                                prov.newSlots[index].availableSlotFlag == 1
                            ? () async {
                                prov.selectedTime(
                                    prov.newSlots[index].startTime,
                                    prov.newSlots[index].endTime,
                                    index);
                              }
                            : null,
                        child: Card(
                          color: prov.newSlots[index].availableSlotFlag == 1
                              ? prov.maxTimeSlots! <= index
                                  ? Colors.white
                                  : Colors.blueGrey
                              : Colors.redAccent,
                          elevation: 10,
                          child: GridTile(
                              header: prov.selectedSlot == index
                                  ? Icon(Icons.check)
                                  : null,
                              child: Center(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        DateFormat('h a')
                                            .format(
                                                prov.newSlots[index].startTime)
                                            .toString(),
                                        style: GoogleFonts.aBeeZee(),
                                      ),
                                      const Text(' - '),
                                      Text(
                                        DateFormat('h a')
                                            .format(
                                                prov.newSlots[index].endTime)
                                            .toString(),
                                        style: GoogleFonts.aBeeZee(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  prov.newSlots[index].availableSlotFlag == 1
                                      ? Text(prov.maxTimeSlots! <= index
                                          ? 'Available'
                                          : 'Not available')
                                      : const Text('Full'),
                                ],
                              ))),
                        ),
                      );
                    },
                  ),
                ),
                prov.isSelected
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                primary: Colors.blueGrey,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 10),
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                )),
                            onPressed: () async {
                              NavigatorState nav = Navigator.of(context);
                              ScaffoldMessengerState message = ScaffoldMessenger.of(context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text('Select service'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 300,
                                              height: 100,
                                              child: services.isNotEmpty ? ListView.builder(
                                                itemCount: services.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(
                                                        () {
                                                          if (index !=
                                                              prov.index) {
                                                            prov.index = index;
                                                            prov.selectService(
                                                                services[
                                                                    index]);
                                                          } else {
                                                            prov.index = -1;
                                                          }
                                                        },
                                                      );
                                                    },
                                                    child: Card(
                                                      shape: prov.index == index
                                                          ? OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))
                                                          : null,
                                                      elevation: 5,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  services[
                                                                          index]
                                                                      .serviceDescription,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                    '${services[index].price.toString()} JD',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            17,
                                                                        color: Colors
                                                                            .green))
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ) : Column(
                                                children:  [
                                                  const Text('no services please try again later'),
                                                  Spacer(),
                                                  ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),onPressed: (){
                                                    nav.pop();
                                                  }, child: const Text('ok'))
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            prov.index! >= 0
                                                ? SizedBox(
                                                    width: 100,
                                                    height: 40,
                                                    child: AppButton(
                                                        text: 'confirm',
                                                        onPressed: () async {
                                                          nav.pop();
                                                          var ok =
                                                              await alertDialogSubmit(
                                                                  context,
                                                                  'are you sure to send to the barber');
                                                          if (ok is bool &&
                                                              ok) {
                                                            await prov
                                                                .sendAppointmentToBarber();
                                                            message.showSnackBar(const SnackBar(content: Text('please wait until the barber accept the appointment')));
                                                            nav.pushReplacement(MaterialPageRoute(builder: (context) => HomePage(),));
                                                          }
                                                        }))
                                                : const SizedBox(),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Confirm',
                              style: TextStyle(color: Colors.black),
                            )),
                      )
                    : const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}
