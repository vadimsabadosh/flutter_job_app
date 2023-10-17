import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_app/views/common/exports.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    super.key,
    required this.controller,
    required this.suffixIcon,
    this.onChanged,
    this.onEditingComplete,
    this.onTapOutside,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final Widget suffixIcon;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final void Function(PointerDownEvent)? onTapOutside;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Color(kDarkGrey.value),
      keyboardType: TextInputType.multiline,
      style: appstyle(16, Color(kDark.value), FontWeight.w500),
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onTapOutside: onTapOutside,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        filled: true,
        fillColor: Color(kLight.value),
        suffixIcon: suffixIcon,
        hintText: "Type a message",
        hintStyle: appstyle(14, Color(kDarkGrey.value), FontWeight.normal),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(24.h),
          ),
          borderSide: BorderSide(color: Color(kDarkGrey.value)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(24.h),
          ),
          borderSide: BorderSide(color: Color(kDarkGrey.value)),
        ),
      ),
    );
  }
}
