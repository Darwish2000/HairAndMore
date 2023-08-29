import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hair_and_more/models/barber.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'barberProfile.dart';

class BarbersCard extends StatelessWidget {
  final Barber barber;

  const BarbersCard(this.barber, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 3.5.w),
        child: Row(

          children: [
            Container(
              height: 12.h,
              width: 17.w,
              child: Image.asset("images/logo.png", fit: BoxFit.fill),
            ),
            SizedBox(
              width: 1.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${barber.firstName} ${barber.lastName}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.h,),
                RatingBar.builder(

                  itemSize: 17,
                  ignoreGestures: true,
                  initialRating: barber.rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                  updateOnDrag: false,
                ),
              ],
            ),
            SizedBox(
              width: 4.w,
            ),
            Spacer(),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => BarberProfile(barber),));
              },
              child: Icon(Icons.arrow_forward),),
          ],
        ),
      ),
    );
  }
}
