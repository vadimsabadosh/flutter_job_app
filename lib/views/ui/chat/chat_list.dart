import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:job_app/controllers/chat_provider.dart';
import 'package:job_app/models/response/chat/get_chats.dart';
import 'package:job_app/views/common/app_bar.dart';
import 'package:job_app/views/common/drawer/drawer_widget.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/common/height_spacer.dart';
import 'package:job_app/views/common/loader.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: const CustomAppBar(
          text: "Chats",
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: DrawerWidget(),
          ),
        ),
      ),
      body: Consumer<ChatNotifier>(
        builder: (context, chatNotifier, child) {
          chatNotifier.getChats();
          chatNotifier.getPrefs();
          return FutureBuilder<List<GetChats>>(
            future: chatNotifier.chats,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: ReusableText(
                    text: snapshot.error.toString(),
                    style: appstyle(20, Color(kOrange.value), FontWeight.bold),
                  ),
                );
              }
              var chats = snapshot.data;
              if (chats!.isEmpty) {
                return const EmptyResultWidget(
                  text: "No chats available",
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  var chat = chats[index];

                  var user = chat.users
                      .where((element) => element.id != chatNotifier.userId);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ChatPage(
                            id: chat.id,
                            title: user.first.username,
                            profile: user.first.profile,
                            users: [chat.users[0].id, chat.users[1].id],
                          ),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: width,
                        decoration: BoxDecoration(
                          color: Color(kLightGrey.value),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 8.h),
                          minLeadingWidth: 0,
                          minVerticalPadding: 0,
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(user.first.profile),
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReusableText(
                                text: user.first.username,
                                style: appstyle(
                                    16, Color(kDark.value), FontWeight.w600),
                              ),
                              const HeightSpacer(size: 5),
                              ReusableText(
                                text: chat.latestMessage.content,
                                style: appstyle(12, Color(kDarkGrey.value),
                                    FontWeight.normal),
                              ),
                            ],
                          ),
                          trailing: Padding(
                            padding: EdgeInsets.only(top: 0, right: 4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                  text: chatNotifier
                                      .msgTime(chat.updatedAt.toString()),
                                  style: appstyle(12, Color(kDarkGrey.value),
                                      FontWeight.normal),
                                ),
                                Icon(chat.chatName == chatNotifier.userId
                                    ? Ionicons.arrow_forward_circle_outline
                                    : Ionicons.arrow_back_circle_outline),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
