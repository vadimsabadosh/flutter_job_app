import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:job_app/models/response/bookmarks/all_bookmarks.dart';
import 'package:job_app/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkHelper {
  static var client = https.Client();

  static Future<bool> addBookmarks(String jobId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    var url = Uri.http(Config.apiUrl, Config.bookmarkUrl);
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode({"job": jobId}));

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> removeBookmarks(String jobId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    var url = Uri.http(Config.apiUrl, "${Config.bookmarkUrl}/$jobId");
    var response = await client.delete(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<AllBookmarks>> getAllBookmarks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    var url = Uri.http(Config.apiUrl, Config.bookmarkUrl);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var bookmarks = allBookmarksFromJson(response.body);
      return bookmarks;
    } else {
      throw Exception('Failed to get all bookmarks');
    }
  }
}
