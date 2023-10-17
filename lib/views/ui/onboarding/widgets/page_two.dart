import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/views/common/app_style.dart';
import 'package:job_app/views/common/height_spacer.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: Color(kDarkBlue.value),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeightSpacer(size: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.55,
                child: Image.asset(
                  'assets/images/page2.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              const HeightSpacer(size: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Stable Yourself \n With Your Ability',
                      textAlign: TextAlign.center,
                      style:
                          appstyle(30, Color(kLight.value), FontWeight.w500)),
                  //const HeightSpacer(size: 10),
                  Padding(
                    padding: EdgeInsets.all(8.h),
                    child: Text(
                      'We help you find your dream job according to your skillset, location and preference to build your career',
                      textAlign: TextAlign.center,
                      style:
                          appstyle(14, Color(kLight.value), FontWeight.normal),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
