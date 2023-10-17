// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:job_app/controllers/bookmark_provider.dart';
import 'package:job_app/controllers/jobs_provider.dart';
import 'package:job_app/models/request/chat/create_chat.dart';
import 'package:job_app/models/request/messaging/send_message.dart';
import 'package:job_app/services/helpers/chat_helper.dart';
import 'package:job_app/services/helpers/message_helper.dart';
import 'package:job_app/views/common/app_bar.dart';
import 'package:job_app/views/common/custom_outline_btn.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/common/height_spacer.dart';
import 'package:job_app/views/ui/chat/chat_list.dart';
import 'package:job_app/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';

class JobPage extends StatefulWidget {
  const JobPage({
    Key? key,
    required this.title,
    required this.id,
  }) : super(key: key);

  final String title;
  final String id;

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(
      builder: (context, notifier, child) {
        notifier.getJob(widget.id);
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: CustomAppBar(
              text: widget.title,
              actions: [
                Consumer<BookMarkNotifier>(
                  builder: (context, bookNotifier, child) {
                    bookNotifier.loadJob();
                    return GestureDetector(
                      onTap: () {
                        if (bookNotifier.jobs.contains(widget.id)) {
                          bookNotifier.removeBookmark(widget.id);
                        } else {
                          bookNotifier.addBookmark(widget.id);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: bookNotifier.jobs.contains(widget.id)
                            ? const Icon(Fontisto.bookmark_alt)
                            : const Icon(Fontisto.bookmark),
                      ),
                    );
                  },
                )
              ],
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.arrow_left),
              ),
            ),
          ),
          body: FutureBuilder(
            future: notifier.job,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              var data = snapshot.data;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const HeightSpacer(size: 30),
                        Container(
                          width: width,
                          height: height * 0.27,
                          color: Color(kLightGrey.value),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(data!.imageUrl),
                              ),
                              const HeightSpacer(size: 10),
                              ReusableText(
                                text: data.title,
                                style: appstyle(
                                    22, Color(kDark.value), FontWeight.w600),
                              ),
                              const HeightSpacer(size: 5),
                              ReusableText(
                                text: data.location,
                                style: appstyle(
                                    16, Color(kDark.value), FontWeight.normal),
                              ),
                              const HeightSpacer(size: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomOutlineBtn(
                                      text: data.contract,
                                      primaryColor: Color(kOrange.value),
                                      width: width * 0.26,
                                      height: height * 0.04,
                                      secondaryColor: Color(kLight.value),
                                    ),
                                    Row(
                                      children: [
                                        ReusableText(
                                          text: data.salary,
                                          style: appstyle(
                                              22,
                                              Color(kDark.value),
                                              FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: width * 0.2,
                                          child: ReusableText(
                                            text: "/${data.period}",
                                            style: appstyle(
                                                22,
                                                Color(kDarkGrey.value),
                                                FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const HeightSpacer(size: 20),
                        ReusableText(
                          text: "Job Description",
                          style:
                              appstyle(22, Color(kDark.value), FontWeight.w600),
                        ),
                        const HeightSpacer(size: 10),
                        Text(
                          data.description,
                          textAlign: TextAlign.justify,
                          maxLines: 8,
                          style: appstyle(
                              16, Color(kDarkGrey.value), FontWeight.normal),
                        ),
                        const HeightSpacer(size: 20),
                        ReusableText(
                          text: "Requirements",
                          style:
                              appstyle(22, Color(kDark.value), FontWeight.w600),
                        ),
                        const HeightSpacer(size: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.requirements.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final req = data.requirements[index];
                            String bullet = '\u2022';
                            return Text("$bullet $req\n",
                                textAlign: TextAlign.justify,
                                maxLines: 4,
                                style: appstyle(16, Color(kDarkGrey.value),
                                    FontWeight.normal));
                          },
                        ),
                        const HeightSpacer(size: 20),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: CustomOutlineBtn(
                              onTap: () {
                                CreateChat model =
                                    CreateChat(userId: data.agentId);

                                ChatHelper.apply(model).then((response) {
                                  if (response[0]) {
                                    print("ChatHelper.apply ok");
                                    SendMessage model = SendMessage(
                                        content:
                                            "Hello, I'm interested in ${data.title} position in ${data.location}",
                                        chatId: response[1],
                                        receiver: data.agentId);

                                    MessagingHelper.sendMessage(model)
                                        .whenComplete(() {
                                      Get.to(() => const MainScreen());
                                    });
                                  }
                                });
                              },
                              width: width,
                              height: height * 0.06,
                              text: "Apply now",
                              secondaryColor: Color(kOrange.value),
                              primaryColor: Color(kLight.value),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
