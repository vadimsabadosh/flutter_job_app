import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_app/views/common/exports.dart';

class EmptyResultWidget extends StatelessWidget {
  const EmptyResultWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/optimized_search.png"),
          SizedBox(
            height: 20.h,
          ),
          ReusableText(
            text: text,
            style: appstyle(
              24,
              Color(kDark.value),
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
