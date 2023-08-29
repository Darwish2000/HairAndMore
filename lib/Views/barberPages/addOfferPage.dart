import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hair_and_more/widgets/appButton.dart';
import 'package:hair_and_more/widgets/formTextField.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controllers/profileSettingsProv.dart';
import '../../models/offer.dart';

class AddOfferPage extends StatelessWidget {
  bool? isDetailsPage = false;
  Offer? offer;

  AddOfferPage({super.key, this.isDetailsPage, this.offer});

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<ProfileSettingsProv>(context);
    return Scaffold(
      appBar: AppBar(
        title: isDetailsPage == false
            ? const Text(
                'Add offer',
                style: TextStyle(color: Colors.black),
              )
            : const Text(
                'Edit offer',
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
      body: FormBuilder(
        key: prov.formKeyOffer,
        initialValue:
            isDetailsPage == true ? {'description': offer!.description} : {},
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'description',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              FormTextField(
                  text: '',
                  name: 'description',
                  textSize: 16,
                  isDescription: true,
                  validator: FormBuilderValidators.required(
                      errorText: 'Description required')),
              const SizedBox(
                height: 20,
              ),
              isDetailsPage == false
                  ? AppButton(
                      text: 'Add offer',
                      onPressed: () async {
                        await prov.addOffer(context);
                      })
                  : AppButton(
                  text: 'Save',
                      onPressed: () async {
                        // var ok = await alertDialogSubmit(context, 'are you sure');
                        // if(ok is bool && ok)
                        //   {
                        await prov.editOffer(context, offer!);
                      })
            ],
          ),
        ),
      ),
    );
  }
}
