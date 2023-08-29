import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hair_and_more/controllers/barberProfileDataProv.dart';
import 'package:provider/provider.dart';

import '../models/barber.dart';
Future rateBarberDialog(BuildContext context,Barber barber) {
  var prov = Provider.of<BarberProfileDataProv>(context,listen: false);
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Align(
        alignment: Alignment.topLeft,
        child: Text('Rate barber'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            itemSize: 25,
            // ignoreGestures: true,
            initialRating: 0,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding:
            const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),

            onRatingUpdate: (rating) {
              if (kDebugMode) {
                prov.setRating(rating);
                print(rating);
              }
            },
            updateOnDrag: false,
          ),

        ],
      ),
      actions: [
        ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey)
        ,onPressed: (){
          Navigator.pop(context);
        }, child: const Text('Cancel')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey)
        ,onPressed: () async {
             await prov.rateBarber(barber);
          Navigator.pop(context);
        }, child: const Text('Submit')),
      ],
    ),
  );
}
