import "package:intl/intl.dart";
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:job_app/models/response/chat/get_chats.dart';
import 'package:job_app/services/helpers/chat_helper.dart';

class ChatNotifier extends ChangeNotifier {
  late Future<List<GetChats>> chats;
  String? userId;
  List<String> _online = [];

  bool _typing = false;

  bool get typing => _typing;

  set typingStatus(bool value) {
    _typing = value;
    notifyListeners();
  }

  List<String> get online => _online;

  set online(List<String> users) {
    _online = users;
    notifyListeners();
  }

  getChats() {
    chats = ChatHelper.getChats();
  }

  getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id');
  }

  String msgTime(String timestamp) {
    DateTime now = DateTime.now();
    DateTime messageTime = DateTime.parse(timestamp);

    if (now.year == messageTime.year &&
        now.month == messageTime.month &&
        now.day == messageTime.day) {
      return DateFormat.Hm().format(messageTime);
    } else if (now.year == messageTime.year &&
        now.month == messageTime.month &&
        (now.day - messageTime.day) == 1) {
      return "Yesterday";
    } else {
      return DateFormat.MMMd().format(messageTime);
    }
  }
}
