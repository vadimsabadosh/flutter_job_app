import 'dart:convert';

import 'package:http/http.dart' as https;
import 'package:job_app/models/request/auth/login_model.dart';
import 'package:job_app/models/request/auth/profile_update_model.dart';
import 'package:job_app/models/request/auth/signup_model.dart';
import 'package:job_app/models/response/auth/login_res_model.dart';
import 'package:job_app/models/response/auth/profile_model.dart';
import 'package:job_app/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static var client = https.Client();

  static Future<bool> login(LoginModel model) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiUrl, Config.loginUrl);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model),
    );

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = loginResponseFromJson(response.body).token;
      String id = loginResponseFromJson(response.body).id;
      String profile = loginResponseFromJson(response.body).profile;

      await prefs.setString('token', token);
      await prefs.setString('id', id);
      await prefs.setString('profile', profile);
      await prefs.setBool('loggedIn', true);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateProfile(
      ProfileUpdateReq model, String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    var url = Uri.http(Config.apiUrl, "${Config.profileUrl}/$userId");
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> signup(SignupModel model) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiUrl, Config.signupUrl);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<ProfileRes> getProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    var url = Uri.http(Config.apiUrl, Config.profileUrl);
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      ProfileRes profile = profileResFromJson(response.body);
      return profile;
    } else {
      throw Exception("Failed to get profile");
    }
  }

  static Future<bool> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    var url = Uri.http(Config.apiUrl, Config.logoutUrl);
    var response = await client.post(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      await prefs.remove('token');
      await prefs.remove('id');
      await prefs.remove('profile');
      await prefs.setBool('loggedIn', false);
      return true;
    } else {
      print(response.body.toString());
      throw Exception("Failed to logout");
    }
  }
}
