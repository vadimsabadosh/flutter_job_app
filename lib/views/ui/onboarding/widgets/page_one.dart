import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/common/height_spacer.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: Color(kDarkPurple.value),
        child: SingleChildScrollView(
          child: Column(children: [
            const HeightSpacer(
              size: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Image.asset(
                'assets/images/page1.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            const HeightSpacer(size: 20),
            Column(
              children: [
                ReusableText(
                  text: "Find Your Dream Job",
                  style: appstyle(30, Color(kLight.value), FontWeight.w500),
                ),
                const HeightSpacer(size: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                  child: Text(
                    'We help you find your dream job according to your skillset, location and preference to build your career',
                    style: appstyle(14, Color(kLight.value), FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                ),
                const HeightSpacer(size: 20),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
