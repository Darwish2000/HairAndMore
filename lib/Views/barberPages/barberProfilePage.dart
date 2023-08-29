import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_and_more/controllers/barberProfileProv.dart';
import 'package:hair_and_more/widgets/appButton.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BarberProfilePage extends StatelessWidget {
  const BarberProfilePage({super.key});


  @override
  Widget build(BuildContext context) {
    return
      ChangeNotifierProvider(
        create: (context) => BarberProfileProv(),
        builder: (context, child) =>
            Consumer<BarberProfileProv>(builder: (context, prov, child) =>
               !prov.isLoading? Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      'Profile',
                      style: TextStyle(color: Colors.black),
                    ),
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),


                  body:
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            height: 150,
                            decoration:
                            const BoxDecoration(shape: BoxShape.circle),
                            child: Center(
                              child: !prov.isFirebaseImage!
                                  ? prov.image == null
                                  ? const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 200,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 100,
                                ),
                              )
                                  : CircleAvatar(
                                radius: 200,
                                backgroundImage:
                                FileImage(prov.image!),
                              )
                                  : Container(
                                  width: 190.0,
                                  height: 190.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              prov.imageUrl!)
                                      )
                                  )),),
                          ),
                          TextButton(
                              onPressed: () {
                                prov.showModelBottomSheet(context);
                              },
                              child: const Text(
                                'Change profile picture',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.blueGrey),
                              )),
                           Text(
                            '${prov.barber!.firstName} ${prov.barber!.lastName}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          RatingBar.builder(
                            itemSize: 20,
                            ignoreGestures: true,
                            initialRating: prov.barber!.rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: const EdgeInsets.symmetric(
                                horizontal: 4.0),
                            itemBuilder: (context, _) =>
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                            updateOnDrag: false,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          ExpansionTile(
                            title: const Text('Services'),
                            children: [
                              prov.services.isNotEmpty
                                  ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(5)),
                                height: 170,
                                width: double.maxFinite,
                                child: ListView.builder(
                                  itemCount: prov.services.length,
                                  itemBuilder: (context, index) =>
                                      Card(
                                        color: Colors.white70,
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: 180,
                                                    child: Text(
                                                      prov.services[index]
                                                          .serviceDescription,
                                                      style: GoogleFonts.openSans(
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                      maxLines: 5,
                                                      textAlign: TextAlign.start,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Price : ',
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 17,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight
                                                          .w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: prov
                                                          .services[index].price
                                                          .toString(),
                                                      style: GoogleFonts
                                                          .openSans(
                                                          fontSize: 16,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                    const TextSpan(text: ' JD'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                ),
                              )
                                  : const Text('No services'),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: const Text('products'),
                            expandedCrossAxisAlignment: CrossAxisAlignment
                                .start,
                            children: [
                              prov.products.isNotEmpty
                                  ? SizedBox(
                                height: 200,
                                width: 380,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: prov.products.length,
                                  itemBuilder: (context, index) =>
                                      Container(
                                        width: 360,
                                        height: 200,
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            // border: Border.all(color: Colors.black),
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                child: Image.network(
                                                  prov.products[index]
                                                      .productImage,
                                                  width: 150,
                                                  height: double.maxFinite,
                                                  fit: BoxFit.fill,
                                                )),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 2.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    height: 90,
                                                    child: SingleChildScrollView(
                                                      scrollDirection:
                                                      Axis.vertical,
                                                      child: Text(
                                                        prov.products[index]
                                                            .productDescription,
                                                        style: GoogleFonts
                                                            .openSans(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                        maxLines: 5,
                                                        textAlign: TextAlign
                                                            .start,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'Price : ',
                                                      style: GoogleFonts
                                                          .openSans(
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: prov
                                                              .products[index]
                                                              .price
                                                              .toString(),
                                                          style:
                                                          GoogleFonts.openSans(
                                                              fontSize: 16,
                                                              color:
                                                              Colors.blue,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                        const TextSpan(
                                                            text: ' JD'),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                ),
                              )
                                  : const Center(
                                child: Text('No products'),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: const Text('Offers'),
                            children: [
                              prov.offers.isNotEmpty
                                  ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(5)),
                                height: 170,
                                width: double.maxFinite,
                                child: ListView.builder(
                                  itemCount: prov.offers.length,
                                  itemBuilder: (context, index) =>
                                      Card(
                                        color: Colors.white70,
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 180,
                                                child: Text(
                                                  prov.offers[index]
                                                      .description,
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .w500),
                                                  maxLines: 5,
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                ),
                              )
                                  : const Text('No offers'),
                              const SizedBox(
                                height: 10,
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Phone No : ${prov.barber!.phoneNo}',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),
                  ),

                ): const Center(child: CircularProgressIndicator(color: Colors.black,)),),

      );
  }
}
