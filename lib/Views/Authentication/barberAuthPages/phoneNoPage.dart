import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hair_and_more/widgets/appButton.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/authProv.dart';

class PhoneNoPage extends StatelessWidget {
  const PhoneNoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    PhoneNumber number = PhoneNumber(isoCode: 'JO');
    var prov = Provider.of<AuthProv>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'images/logo.png',
                width: 180,
                height: 160,
                fit: BoxFit.fill,
              ),
            ),
            const Text(
              'Please add your phone number.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                prov.addPhoneNum(number.phoneNumber);
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              inputDecoration: !prov.valid? const InputDecoration(
                errorText: 'please add valid phone number',
                enabledBorder:OutlineInputBorder()
              ) : null,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: const TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: controller,
              formatInput: true,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              inputBorder: const OutlineInputBorder(),
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
                text: 'Confirm',
                onPressed: () async {
                  if (prov.phoneNo?.length == 13) {
                    print('done');
                    prov.valid = true;
                    prov.notifyListeners();
                    prov.otpFunction(context);
                  }
                  else
                    {
                      print('not done');
                      prov.valid = false;
                      prov.notifyListeners();
                    }
                })
          ],
        ),
      ),
    );
  }
}
