import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:job_app/controllers/onboarding_provider.dart';
import 'package:job_app/views/common/custom_outline_btn.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/common/height_spacer.dart';
import 'package:job_app/views/ui/auth/login.dart';
import 'package:job_app/views/ui/auth/signup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OnBoardNotifier>(
        builder: (context, state, child) {
          return Container(
            width: width,
            height: height,
            color: Color(kLightBlue.value),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Image.asset(
                      'assets/images/page3.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  const HeightSpacer(size: 20),
                  ReusableText(
                    text: "Welcome To Jobhub",
                    style: appstyle(30, Color(kLight.value), FontWeight.w600),
                  ),
                  const HeightSpacer(size: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Text(
                      'We help you find your dream job according to your skillset, location and preference to build your career',
                      textAlign: TextAlign.center,
                      style:
                          appstyle(14, Color(kLight.value), FontWeight.normal),
                    ),
                  ),
                  const HeightSpacer(size: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomOutlineBtn(
                        onTap: () async {
                          state.setOnboardingPassed();
                          Get.to(() => const LoginPage());
                        },
                        text: 'Login',
                        width: width * 0.4,
                        height: height * 0.06,
                        primaryColor: Color(kLight.value),
                      ),
                      GestureDetector(
                        onTap: () {
                          state.setOnboardingPassed();
                          Get.to(() => const RegistrationPage());
                        },
                        child: Container(
                          width: width * 0.4,
                          height: height * 0.06,
                          color: Color(kLight.value),
                          child: Center(
                            child: ReusableText(
                                text: 'Sign Up',
                                style: appstyle(16, Color(kLightBlue.value),
                                    FontWeight.w600)),
                          ),
                        ),
                      )
                    ],
                  ),
                  const HeightSpacer(size: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
