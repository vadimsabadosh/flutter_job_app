import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:job_app/controllers/chat_provider.dart';
import 'package:job_app/models/request/messaging/send_message.dart';
import 'package:job_app/models/response/messaging/messaging_res.dart';
import 'package:job_app/services/helpers/message_helper.dart';
import 'package:job_app/views/common/app_bar.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/common/height_spacer.dart';
import 'package:job_app/views/common/loader.dart';
import 'package:job_app/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'widgets/text_field.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key,
      required this.title,
      required this.id,
      required this.profile,
      required this.users});

  final String title;
  final String id;
  final String profile;
  final List<String> users;

  @override
  State<ChatPage> createState() => ChatState();
}

class ChatState extends State<ChatPage> {
  int page = 1;

  IO.Socket? socket;

  late Future<List<ReceivedMessage>> msgList;
  List<ReceivedMessage> messages = [];
  TextEditingController controller = TextEditingController();
  String receiver = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getMessages(page);
    connect();
    joinChat();
    handleNext();
    super.initState();
  }

  void getMessages(int currPage) {
    msgList = MessagingHelper.getMeesages(widget.id, currPage);
  }

  void handleNext() {
    _scrollController.addListener(() async {
      if (_scrollController.hasClients) {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          print("<><><><><><><><><><><><><><><><<><><<><><><>");
          if (messages.length >= 12) {
            getMessages(page++);
            setState(() {});
          }
        }
      }
    });
  }

  void connect() {
    var chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
    socket = IO.io(
        "https://jobappbackend-production-1f10.up.railway.app",
        <String, dynamic>{
          "transports": ["websocket"],
          "autoConnect": false,
        });

    socket!.emit("setup", chatNotifier.userId);
    socket!.connect();
    socket!.onConnect((_) {
      print("Connected to front end");
      socket!.on("online-users", (userId) {
        chatNotifier.online
            .replaceRange(0, chatNotifier.online.length, [userId]);
      });

      socket!.on("typing", (status) {
        chatNotifier.typingStatus = true;
      });

      socket!.on("stop typing", (status) {
        chatNotifier.typingStatus = false;
      });
      socket!.on("message received", (newMessageReceived) {
        sendStopTypingEvent(widget.id);
        ReceivedMessage receivedMessage =
            ReceivedMessage.fromJson(newMessageReceived);

        if (receivedMessage.sender.id != chatNotifier.userId) {
          setState(() {
            messages.insert(0, receivedMessage);
          });
        }
      });
    });
  }

  void sendTypingEvent(String status) {
    socket!.emit("typing", status);
  }

  void sendStopTypingEvent(String status) {
    socket!.emit("stop typing", status);
  }

  void joinChat() {
    socket!.emit("join chat", widget.id);
  }

  void sendMessage(String content, String chatId, String receiver) {
    SendMessage model =
        SendMessage(chatId: chatId, content: content, receiver: receiver);

    MessagingHelper.sendMessage(model).then(
      (response) {
        var emmission = response[2];
        socket!.emit("new message", emmission);
        sendStopTypingEvent(widget.id);
        setState(() {
          controller.clear();
          messages.insert(0, response[1]);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatNotifier>(
      builder: (context, chatNotifier, child) {
        receiver = widget.users.firstWhere((id) => id != chatNotifier.userId);
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.h),
              child: CustomAppBar(
                text: chatNotifier.typing ? "Typing...." : widget.title,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          //backgroundImage: NetworkImage(widget.profile),
                          backgroundColor: Color(kOrange.value),
                        ),
                        Positioned(
                          right: 3,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor:
                                chatNotifier.online.contains(receiver)
                                    ? Colors.green
                                    : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      //Get.back();
                      Get.to(() => const MainScreen());
                    },
                    child: const Icon(MaterialCommunityIcons.arrow_left),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.h),
                child: Column(
                  children: [
                    Expanded(
                      child: FutureBuilder<List<ReceivedMessage>>(
                        future: msgList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: ReusableText(
                                text: snapshot.error.toString(),
                                style: appstyle(
                                    20, Color(kOrange.value), FontWeight.bold),
                              ),
                            );
                          }
                          var chats = snapshot.data;
                          messages = messages + (chats ?? []);
                          if (messages.isEmpty) {
                            return const EmptyResultWidget(
                              text: "You do not have messages yet",
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: messages.length,
                            reverse: true,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              var data = messages[index];
                              return Padding(
                                padding:
                                    EdgeInsets.only(top: 8.h, bottom: 12.h),
                                child: Column(
                                  children: [
                                    ReusableText(
                                      text: chatNotifier.msgTime(
                                          data.chat.updatedAt.toString()),
                                      style: appstyle(10, Color(kDark.value),
                                          FontWeight.normal),
                                    ),
                                    const HeightSpacer(size: 15),
                                    ChatBubble(
                                      alignment:
                                          data.sender.id == chatNotifier.userId
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                      backGroundColor:
                                          data.sender.id == chatNotifier.userId
                                              ? Color(kOrange.value)
                                              : Color(kLightBlue.value),
                                      elevation: 0,
                                      clipper: ChatBubbleClipper2(
                                          radius: 8,
                                          type: data.sender.id ==
                                                  chatNotifier.userId
                                              ? BubbleType.sendBubble
                                              : BubbleType.receiverBubble),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: width * 0.8),
                                        child: ReusableText(
                                          text: data.content,
                                          style: appstyle(
                                              14,
                                              Color(kLight.value),
                                              FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(12.h),
                      alignment: Alignment.bottomCenter,
                      child: MessageTextField(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            sendMessage(controller.text, widget.id, receiver);
                          },
                          child: const Icon(
                            Icons.send,
                            size: 24,
                          ),
                        ),
                        onChanged: (_) {
                          sendTypingEvent(widget.id);
                        },
                        onEditingComplete: () {
                          sendMessage(controller.text, widget.id, receiver);
                        },
                        onTapOutside: (_) {
                          sendStopTypingEvent(widget.id);
                        },
                        onSubmitted: (_) {
                          sendMessage(controller.text, widget.id, receiver);
                        },
                        controller: controller,
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
