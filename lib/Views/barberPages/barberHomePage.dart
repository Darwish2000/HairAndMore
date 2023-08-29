import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:hair_and_more/Views/barberPages/BarberSideMenu.dart';
import 'package:hair_and_more/Views/barberPages/barberProfilePage.dart';
import 'package:hair_and_more/controllers/appointmentProv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utils/textStyle.dart';
import '../../widgets/submitDialog.dart';

class BarberHomePage extends StatelessWidget {
  const BarberHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final advancedDrawerController = AdvancedDrawerController();

    return ChangeNotifierProvider(
      create: (context) => AppointmentProv(),
      builder: (context, child) => Consumer<AppointmentProv>(
        builder: (context, prov, child) {
          return AdvancedDrawer(
            backdropColor: Colors.blueGrey,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 400),
            animateChildDecoration: true,
            rtlOpening: false,
            disabledGestures: false,
            childDecoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            controller: advancedDrawerController,
            drawer: const BarberSideMenu(),
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: InkWell(
                  onTap: () {
                    advancedDrawerController.showDrawer();
                  },
                  child: const Icon(
                    Icons.short_text,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BarberProfilePage(),
                          ));
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(13)),
                      child: Container(
                        height: 40,
                        width: 60,
                        child: Image.asset("images/logo.png", fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ],
              ),
              body: !prov.isLoading
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello,",
                              style: TextStyles.title,
                            ),
                            Text('${prov.barber!.firstName} ${prov.barber!.lastName}', style: TextStyles.h1Style),
                            SizedBox(
                              height: 2.h,
                            ),
                            const Divider(),
                            const Text(
                              "Appointments",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            prov.appointments.isNotEmpty
                                ? SizedBox(
                                    height: 63.h,
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: prov.appointments.length,
                                        itemBuilder: (context, index) => Card(
                                              elevation: 5,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.h,
                                                    horizontal: 3.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          '${prov.appointments[index].userFirstName} ${prov.appointments[index].userLastName}',
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          DateFormat('hh:mm a').format(prov.appointments[index].submitDate),
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    // const Text(
                                                    //   'Phone No : +962797810122',
                                                    //   style:
                                                    //       TextStyle(fontSize: 17),
                                                    // ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          'reservation time : ',
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          DateFormat('h a')
                                                              .format(prov
                                                                  .appointments[
                                                                      index]
                                                                  .startTime),
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                            fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        const Text(
                                                          "  -  ",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat('h a')
                                                              .format(prov
                                                                  .appointments[
                                                                      index]
                                                                  .endTime),
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          'Service : ',
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          prov
                                                              .appointments[
                                                          index]
                                                              .service,
                                                          style: const TextStyle(
                                                              fontSize: 18,fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            var ok =
                                                                await alertDialogSubmit(
                                                                    context,
                                                                    'Are you sure to accept appointment');
                                                            if (ok is bool &&
                                                                ok) {
                                                              await prov
                                                                  .acceptAppointment(
                                                                      prov.appointments[
                                                                          index],context);
                                                              print(prov
                                                                  .appointments[
                                                                      index]
                                                                  .token);
                                                              // await   FirebaseMessaging.instance.sendMessage(to: "${prov.appointments[index].token}",data: {"title":"awd","body":"body"},ttl: 300);

                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  elevation: 2,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .lightGreen),
                                                          child: const Text(
                                                              'Accept'),
                                                        ),
                                                        SizedBox(width: 3.w),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            var ok = await alertDialogSubmit(context, "Are you sure to reject appointment?");
                                                            if(ok is bool && ok){
                                                              prov.rejectAppointment(prov.appointments[index], context);
                                                            }

                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  elevation: 2,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .redAccent),
                                                          child: const Text(
                                                              'Reject'),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      const Center(
                                          child: Text(
                                        'no appointments added yet',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                      color: Colors.black,
                    )),
            ),
          );
        },
      ),
    );
  }
}
