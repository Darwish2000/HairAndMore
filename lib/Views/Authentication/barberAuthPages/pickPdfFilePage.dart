import 'package:better_open_file/better_open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:hair_and_more/widgets/appButton.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/authProv.dart';

class PickPdfFilePage extends StatelessWidget {

  String ?barberId;
  PickPdfFilePage(this.barberId);

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<AuthProv>(context);
    return Scaffold(
      appBar: AppBar(
        title: prov.isSelected
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profession certificate',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                      onPressed: () async {
                        prov.uploadFile(barberId!,context);
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              )
            : const Text('Profession certificate',
                style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          children: [
            const Text(
              'To access the barber application, please attach your professional certificate.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),

            Expanded(
                child: SizedBox(
              width: double.maxFinite,
              child: Card(
                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.grey, ),
                elevation: 30,


                child: prov.file != null
                    ? PDFView(filePath: prov.file!.path,)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.file_upload_outlined, size: 100),
                          Text('PDF file',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ))
                        ],
                      ),
              ),
            )),
            SizedBox(
              height: 2.h,
            ),
            AppButton(
                text: 'select file',
                onPressed: () async {

                  final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  );
                  if (result == null) return;

                  ///open single file

                  prov.savePdfFile(result.files.first);
                },
                textSize: 20),
            // TextButton(child: const Text('upload',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),onPressed: () async {
            //
            // }),
          ],
        ),
      ),
    );
  }
}
