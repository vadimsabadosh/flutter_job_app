import 'package:flutter/material.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.onTap, required this.text, this.color});
  final void Function() onTap;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Color(kOrange.value),
        width: width,
        height: height * 0.065,
        child: Center(
          child: ReusableText(
            text: text,
            style: appstyle(16, color ?? Color(kLight.value), FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
