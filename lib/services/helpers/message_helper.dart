import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:job_app/models/request/messaging/send_message.dart';
import 'package:job_app/models/response/messaging/messaging_res.dart';
import 'package:job_app/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagingHelper {
  static var client = https.Client();

// SEND A MESSAGE
  static Future<List<dynamic>> sendMessage(SendMessage model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    var url = Uri.https(Config.apiUrl, Config.messagesUrl);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      ReceivedMessage message =
          ReceivedMessage.fromJson(jsonDecode(response.body));

      Map<String, dynamic> responseMap = jsonDecode(response.body);

      return [true, message, responseMap];
    } else {
      throw Exception("Failed to send message");
    }
  }

// GET MESSAGES
  static Future<List<ReceivedMessage>> getMeesages(
      String chatId, int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    var url = Uri.https(
      Config.apiUrl,
      "${Config.messagesUrl}/$chatId",
      {"page": page.toString()},
    );
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      List<ReceivedMessage> messages = receivedMessageFromJson(response.body);

      return messages;
    } else {
      throw Exception("Failed to send message");
    }
  }
}
