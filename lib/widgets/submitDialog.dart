import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
Future alertDialogSubmit(BuildContext context,String text) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Align(
        alignment: Alignment.topLeft,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          SizedBox(
            height: 3.5.h,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey
                ),

                child:const Text('Yes'),
              ),
              SizedBox(width: 1.w),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey
                ),
                  child:const Text('Cancel'),
              ),
            ],
          ),

        ],
      ),
    ),
  );
}
