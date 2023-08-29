// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FormTextField extends StatefulWidget {
  final String text;
  final Icon? icon;
  double textSize;
  final String name;
  bool shadow;
  bool isSecure;
  Icon? sIcon;
  bool showpass;
  bool isPhone;
  bool enabled;
  var value;
  bool isDescription;
  var validator;
  ValueChanged<String?>? onChanged;
  TextEditingController? controller;
  bool digitOnly;

  // String? Function(dynamic val)? validator;

  FormTextField({
    super.key,
    this.showpass = true,
    this.isPhone = false,
    this.isSecure = false,
    this.sIcon,
    required this.text,
    this.icon,
    this.textSize = 15,
    this.shadow = false,
    required this.name,
    this.enabled = true,
    this.value,
    this.onChanged,
    this.controller,
    this.validator,
    this.isDescription = false,
    this.digitOnly = false,
  });

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 169, 165, 165),
          spreadRadius: -4,
          blurRadius: 12,
          //offset: Offset(0, 4),
        )
      ]),
      child: FormBuilderTextField(
        obscureText: widget.showpass && widget.isSecure,
        name: widget.name,
        validator: widget.validator,
        inputFormatters: widget.digitOnly ? [FilteringTextInputFormatter.digitsOnly] : [],
        onChanged: widget.onChanged,
        controller: widget.controller,
        maxLines: widget.isDescription ? 4 : 1,
        style: TextStyle(overflow: TextOverflow.visible),
        enabled: widget.enabled,
        initialValue: widget.value,
        keyboardType:
            widget.isPhone ? TextInputType.phone : TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white10),
              borderRadius: BorderRadius.circular(15)),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: widget.shadow
                  ? BorderSide.none
                  : BorderSide(color: Colors.black54)),
          labelText: widget.text,
          prefixIcon: widget.icon,
          suffixIcon: !widget.isSecure
              ? widget.sIcon
              : IconButton(
                  onPressed: () {
                    setState(() {
                      widget.showpass = !(widget.showpass);
                    });
                  },
                  icon: widget.showpass
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off)),
          labelStyle: TextStyle(
            fontSize: widget.textSize.sp,
          ),
        ),
      ),
    );
  }
}
