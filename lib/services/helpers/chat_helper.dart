import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:job_app/models/request/chat/create_chat.dart';
import 'package:job_app/models/response/chat/get_chats.dart';
import 'package:job_app/models/response/chat/initial_chat.dart';
import 'package:job_app/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHelper {
  static var client = https.Client();

// APPLY FOR A JOB
  static Future<List<dynamic>> apply(CreateChat model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    var url = Uri.http(Config.apiUrl, Config.chatUrl);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      var id = initialChatFromJson(response.body).id;

      return [true, id];
    } else {
      print("ChatHelper.apply false");
      return [false];
    }
  }

// APPLY FOR A JOB
  static Future<List<GetChats>> getChats() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    var url = Uri.http(Config.apiUrl, Config.chatUrl);
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var chats = getChatsFromJson(response.body);

      return chats;
    } else {
      throw Exception("Failed to get chats");
    }
  }
}
