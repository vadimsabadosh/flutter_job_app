import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as https;
import 'package:image_picker/image_picker.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  static var client = https.Client();

  static Future<String?> uploadPhoto(XFile file) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer $token"
    };

    var url = Uri.https(Config.apiUrl, Config.uploadPhotoUrl);

    var request = https.MultipartRequest("POST", url);

    https.MultipartFile multipartFile =
        await https.MultipartFile.fromPath('file', file.path);

    request.headers.addAll(requestHeaders);

    request.files.add(multipartFile);
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var responseString = jsonDecode(String.fromCharCodes(responseData));
      return responseString["profile"];
    } else {
      Get.snackbar(
        "Upload Failed",
        "Please try again later",
        colorText: Color(kLight.value),
        backgroundColor: Colors.red,
        icon: const Icon(
          Icons.add_alert,
          color: Colors.white,
        ),
      );
      return null;
    }
  }
}
