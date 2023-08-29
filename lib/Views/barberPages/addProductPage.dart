import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hair_and_more/controllers/profileSettingsProv.dart';
import 'package:hair_and_more/widgets/appButton.dart';
import 'package:hair_and_more/widgets/formTextField.dart';
import 'package:hair_and_more/widgets/submitDialog.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/product.dart';

class AddProductPage extends StatelessWidget {
  Product? product;
  bool? isDetailsPage = false;

  AddProductPage({this.product, this.isDetailsPage});

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<ProfileSettingsProv>(context);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: isDetailsPage == false
            ? const Text(
                'Add product',
                style: TextStyle(color: Colors.black),
              )
            : const Text(
                'Edit product',
                style: TextStyle(color: Colors.black),
              ),
        centerTitle: true,






        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            prov.image = null;
            Provider.of<ProfileSettingsProv>(context,listen: false).notifyListeners();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        child: FormBuilder(
          initialValue: isDetailsPage!
              ? {
                  'description': product!.productDescription,
                  'price': product!.price.toString(),
                }
              : {},
          key: prov.formKeyProduct,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add image',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                    onTap: () {
                      prov.showModelBottomSheet(context);
                    },
                    child: isDetailsPage == false
                        ? SizedBox(
                            width: double.maxFinite,
                            height: 200,
                            child: prov.image == null
                                ? Card(
                                    elevation: 10,
                                    color: Colors.blueGrey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.image_outlined,
                                          size: 60,
                                        ),
                                        Icon(
                                          Icons.add,
                                          size: 60,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: double.maxFinite,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: FileImage(prov.image!)))),
                          )

                        :prov.image == null ? SizedBox(
                            width: double.maxFinite,
                            height: 200,
                            child: Container(
                                width: double.maxFinite,
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            product!.productImage)))),
                          ) : Container(
                        width: double.maxFinite,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: FileImage(prov.image!)))) ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                FormTextField(
                    text: '',
                    name: 'description',
                    isDescription: true,
                    validator: FormBuilderValidators.required(
                        errorText: 'Description required')),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Price : ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                isDetailsPage == false
                    ? AppButton(
                        text: 'Add Product',
                        onPressed: () async {
                          await prov.addProduct(context);
                        })
                    : AppButton(
                        text: 'Save',
                        onPressed: () async {
                          // var ok = await alertDialogSubmit(context, 'are you sure');
                          // if(ok is bool && ok)
                          //   {
                              await prov.editProduct(context,product!);
                        })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
