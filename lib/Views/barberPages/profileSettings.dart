import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_and_more/controllers/profileSettingsProv.dart';
import 'package:hair_and_more/models/product.dart';
import 'package:hair_and_more/widgets/appButton.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widgets/submitDialog.dart';
import 'addOfferPage.dart';
import 'addProductPage.dart';
import 'addServicePage.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<ProfileSettingsProv>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile settings',
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
      body: !prov.isLoading
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  itemBuilder: (context, index) => Card(
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
                                              const Spacer(),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddServicePage(
                                                                service:
                                                                    prov.services[
                                                                        index],
                                                                isDetailsPage:
                                                                    true,
                                                              )));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 2,
                                                    backgroundColor:
                                                        Colors.blueGrey),
                                                child: const Text('Edit'),
                                              ),
                                              SizedBox(width: 1.w),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  var ok = await alertDialogSubmit(
                                                      context,
                                                      'Are you sure to remove this service');
                                                  if (ok is bool && ok) {
                                                    prov.removeService(context,
                                                        prov.services[index]);
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 2,
                                                    backgroundColor:
                                                        Colors.red),
                                                child: const Text('Remove'),
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
                                                  fontWeight: FontWeight.w500),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: prov
                                                      .services[index].price
                                                      .toString(),
                                                  style: GoogleFonts.openSans(
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
                        Center(
                          child: AppButton(
                              width: 50,
                              textSize: 16,
                              height: 5,
                              text: 'Add new service',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddServicePage(isDetailsPage: false),
                                    ));
                              }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('products'),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
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
                                  itemBuilder: (context, index) => Container(
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
                                              prov.products[index].productImage,
                                              width: 150,
                                              height: double.maxFinite,
                                              fit: BoxFit.fill,
                                            )),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 2.h),
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
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 5,
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Price : ',
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 17,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: prov
                                                          .products[index].price
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
                                                    const TextSpan(text: ' JD'),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AddProductPage(
                                                                    product: prov
                                                                            .products[
                                                                        index],
                                                                    isDetailsPage:
                                                                        true,
                                                                  )));
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            elevation: 2,
                                                            backgroundColor:
                                                                Colors
                                                                    .blueGrey),
                                                    child: const Text('Edit'),
                                                  ),
                                                  SizedBox(width: 2.w),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      var ok =
                                                          await alertDialogSubmit(
                                                              context,
                                                              'Are you sure to remove this product');
                                                      if (ok is bool && ok) {
                                                        prov.removeProduct(
                                                            prov.products[
                                                                index],
                                                            context);
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            elevation: 2,
                                                            backgroundColor:
                                                                Colors.red),
                                                    child: const Text('Remove'),
                                                  ),
                                                ],
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
                        Center(
                          child: AppButton(
                              width: 50,
                              textSize: 16,
                              height: 5,
                              text: 'Add new Product',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddProductPage(isDetailsPage: false),
                                    ));
                              }),
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
                                  itemBuilder: (context, index) => Card(
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
                                              prov.offers[index].description,
                                              style: GoogleFonts.openSans(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 5,
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Spacer(),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddOfferPage(
                                                            offer: prov
                                                                .offers[index],
                                                            isDetailsPage: true,
                                                          )));
                                            },
                                            style: ElevatedButton.styleFrom(
                                                elevation: 2,
                                                backgroundColor:
                                                    Colors.blueGrey),
                                            child: const Text('Edit'),
                                          ),
                                          SizedBox(width: 1.w),
                                          ElevatedButton(
                                            onPressed: () async {
                                              var ok = await alertDialogSubmit(
                                                  context,
                                                  'Are you sure to remove this offer');
                                              if (ok is bool && ok) {
                                                prov.removeOffer(
                                                    prov.offers[index],
                                                    context);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                elevation: 2,
                                                backgroundColor: Colors.red),
                                            child: const Text('Remove'),
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
                        Center(
                          child: AppButton(
                              width: 50,
                              textSize: 16,
                              height: 5,
                              text: 'Add new offer',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddOfferPage(isDetailsPage: false),
                                    ));
                              }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],

                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
    );
  }
}
