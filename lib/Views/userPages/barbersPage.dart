import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'barbersCard.dart';

class BarbersPage extends StatelessWidget {
  List barbers = [];

  BarbersPage(this.barbers, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'barbers',
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
          const Text(
            'all barbers',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 1.h,),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount:barbers.length,
              itemBuilder: (context, index) =>
                  BarbersCard(barbers[index]),
            ),
          ),
        ],),
      ),
    );
  }
}
