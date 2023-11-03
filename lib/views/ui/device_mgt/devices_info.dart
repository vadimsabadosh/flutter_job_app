import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_app/controllers/exports.dart';
import 'package:job_app/views/common/app_bar.dart';
import 'package:job_app/views/common/drawer/drawer_widget.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/common/height_spacer.dart';
import 'package:provider/provider.dart';

import 'widgets/device_info.dart';

class DeviceManagement extends StatelessWidget {
  const DeviceManagement({super.key});

  @override
  Widget build(BuildContext context) {
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    String date = DateTime.now().toString();
    var loginDate = date.substring(0, 11);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: const CustomAppBar(
          text: "Devices",
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: DrawerWidget(),
          ),
        ),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeightSpacer(size: 30),
                Text('You are logged in into your account on these devices',
                    style: appstyle(16, Color(kDark.value), FontWeight.normal)),
                const HeightSpacer(size: 50),
                DeviceInfo(
                  date: loginDate,
                  device: 'MacBook M2',
                  ipAddress: '10.10.12.110',
                  location: 'Washington D.C.',
                  platform: 'Apple Webkit',
                ),
                const HeightSpacer(size: 50),
                DeviceInfo(
                  date: loginDate,
                  device: 'Iphone 14 Pro',
                  ipAddress: '10.10.12.110',
                  location: 'Brooklyn',
                  platform: 'Safari',
                ),
              ],
            ),
          ),
          Consumer<LoginNotifier>(
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    await value.logout();
                    zoomNotifier.currentIndex = 0;
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ReusableText(
                      text: "Sign Out from all devices",
                      style:
                          appstyle(16, Color(kOrange.value), FontWeight.w600),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      )),
    );
  }
}
