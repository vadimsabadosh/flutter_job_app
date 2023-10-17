import 'package:flutter/material.dart';
import 'package:job_app/views/common/exports.dart';

class HeadingWidget extends StatelessWidget {
  const HeadingWidget({super.key, required this.text, required this.onTap});
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ReusableText(
          text: text,
          style: appstyle(20, Color(kDark.value), FontWeight.w600),
        ),
        GestureDetector(
          onTap: onTap,
          child: ReusableText(
            text: 'View All',
            style: appstyle(16, Color(kOrange.value), FontWeight.w400),
          ),
        )
      ],
    );
  }
}
