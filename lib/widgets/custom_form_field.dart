import 'package:flutter/material.dart';

import 'constant.dart';

// ignore: must_be_immutable
class CustomFormField extends StatelessWidget {
  CustomFormField(
      {Key? key,
        this.hintText,
        this.onTap,
        this.textInputType,
        this.width,
        this.validate,
        this.label,
        this.suffix,
        this.controller,
        this.onTapp,
        this.onChanged,
        this.height,
        this.textAlign,
        this.icon,
        this.colorText,
        this.colorBorder,
        this.validationPassed,
        this.obscureText = false
      }) : super(key: key);

  void Function(String)? onTapp;
  void Function()? onTap;
  String? hintText;
  String? label;
  TextEditingController? controller;
  String? Function(String?)? validate;
  double? width;
  double? height;
  Color? colorBorder;
  bool? obscureText;
  TextStyle? colorText;
  TextInputType? textInputType;
  TextAlign? textAlign;
  Widget? suffix;
  Icon? icon;
  void Function(String)? onChanged;
  bool? validationPassed=false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:validationPassed==false? 48:68,
      child: TextFormField(
        controller: controller,
        keyboardType:textInputType?? TextInputType.text ,
        obscureText: obscureText!,
        onTap: onTap,
        validator: validate,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          suffixIconColor: primaryColor,
          suffixIcon: icon,
          hintStyle: const TextStyle(fontSize: 14,color: Colors.grey),
          labelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: primaryColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:primaryColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 2.0,
                color:primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),

        ),
      ),
    );
  }
}
