import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:job_app/controllers/jobs_provider.dart';
import 'package:job_app/views/common/app_bar.dart';
import 'package:job_app/views/common/app_style.dart';
import 'package:job_app/views/common/drawer/drawer_widget.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/common/heading_widget.dart';
import 'package:job_app/views/common/height_spacer.dart';
import 'package:job_app/views/common/search.dart';
import 'package:job_app/views/common/vertical_shimmer.dart';
import 'package:job_app/views/common/vertical_tile.dart';
import 'package:job_app/views/ui/jobs/job_page.dart';
import 'package:job_app/views/ui/jobs/jobs_list.dart';
import 'package:job_app/views/ui/jobs/widgets/horizontal_shimmer.dart';
import 'package:job_app/views/ui/jobs/widgets/horizontal_tile.dart';
import 'package:job_app/views/ui/search/searchpage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            actions: [
              Padding(
                padding: EdgeInsets.all(12.h),
                child: const CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
              )
            ],
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: DrawerWidget(),
            ),
          ),
        ),
        body: Consumer<JobsNotifier>(
          builder: (context, jobsNotifier, child) {
            jobsNotifier.getJobs();
            jobsNotifier.getRecentJob();
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search \nFind & Apply',
                        style:
                            appstyle(40, Color(kDark.value), FontWeight.bold),
                      ),
                      const HeightSpacer(size: 40),
                      SearchWidget(onTap: () {
                        Get.to(() => const SearchPage());
                      }),
                      const HeightSpacer(size: 30),
                      HeadingWidget(
                        text: "Popular Jobs",
                        onTap: () {
                          Get.to(() => const JobListPage());
                        },
                      ),
                      const HeightSpacer(size: 10),
                      SizedBox(
                        height: height * 0.28,
                        child: FutureBuilder(
                          future: jobsNotifier.jobList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return HorizontalShimmer();
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else {
                              final jobs = snapshot.data;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: jobs!.length,
                                itemBuilder: (context, item) {
                                  final job = jobs[item];
                                  return JobHorizontalTile(
                                    job: job,
                                    onTap: () {
                                      Get.to(
                                        () => JobPage(
                                            title: job.company, id: job.id),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      const HeightSpacer(size: 20),
                      HeadingWidget(
                        text: "Recently Posted",
                        onTap: () {},
                      ),
                      const HeightSpacer(size: 10),
                      FutureBuilder(
                        future: jobsNotifier.recentJob,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return VerticalShimmer();
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else {
                            final job = snapshot.data;
                            return VerticalTile(
                              job: job!,
                              onTap: () {
                                Get.to(
                                  () => JobPage(title: job.company, id: job.id),
                                );
                              },
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
