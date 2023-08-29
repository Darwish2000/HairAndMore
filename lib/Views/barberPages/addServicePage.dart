import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hair_and_more/widgets/appButton.dart';
import 'package:hair_and_more/widgets/formTextField.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controllers/profileSettingsProv.dart';
import '../../models/service.dart';

class AddServicePage extends StatelessWidget {
  bool? isDetailsPage = false;
  Service? service;

  AddServicePage({super.key, this.isDetailsPage, this.service});

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<ProfileSettingsProv>(context);
    return Scaffold(
      appBar: AppBar(
        title: isDetailsPage == false
            ? const Text(
                'Add service',
                style: TextStyle(color: Colors.black),
              )
            : const Text(
                'Edit service',
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
        key: prov.formKeyService,
        initialValue: isDetailsPage == true
            ? {'description': service!.serviceDescription,'price':service!.price.toString()}
            : {},
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
                height: 12,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Price : ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 110,
                    child: FormTextField(
                      text: '',
                      name: 'price',
                      isPhone: true,
                      validator: FormBuilderValidators.required(
                        errorText: 'Price required',
                      ),
                      digitOnly: true,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'JD',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              isDetailsPage == false
                  ? AppButton(
                      text: 'Add service',
                      onPressed: () async {
                        await prov.addService(context);
                      })
                  : AppButton(
                      text: 'Save',
                      onPressed: () async {
                        await prov.editService(context, service!);
                      })
            ],
          ),
        ),
      ),
    );
  }
}
