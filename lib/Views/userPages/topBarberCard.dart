import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_and_more/Views/userPages/barberProfile.dart';
import 'package:hair_and_more/models/barber.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '';
class TopBarberCard extends StatelessWidget {
  final Barber barber;
  const TopBarberCard(this.barber, {super.key});
  @override
  Widget build(BuildContext context) {
    return barber.rating > 4 ? InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => BarberProfile(barber),));
      },
      child: Card(
        color: Colors.blueGrey,
        elevation: 5,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 4.w),
          child: Center(
            child: Row(mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(barber.firstName,style: const TextStyle(fontSize: 17),),
                  SizedBox(height : 2.h),
                  Text('${barber.reviews.toString()} Reviews',style: const TextStyle(fontSize: 17),),
                ],
              ),
            SizedBox(width: 1.w,),
            RatingBar.builder(
              itemSize: 17,
              ignoreGestures: true,
              initialRating: barber.rating,
              minRating: 1,
              direction: Axis.vertical,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
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
          ),
        ),
      ),
    ) : SizedBox();
  }
}
