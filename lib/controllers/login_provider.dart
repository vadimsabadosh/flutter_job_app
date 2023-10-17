import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/models/request/auth/login_model.dart';
import 'package:job_app/models/request/auth/profile_update_model.dart';
import 'package:job_app/services/helpers/auth_helper.dart';
import 'package:job_app/views/ui/auth/update_user.dart';
import 'package:job_app/views/ui/homepage.dart';
import 'package:job_app/views/ui/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class LoginNotifier extends ChangeNotifier {
  bool _obscureText = true;
  bool _firstTime = true;
  bool? _entrypoint;
  bool? _loggedIn;

  final loginFormValue = GlobalKey<FormState>();
  final profileFormValue = GlobalKey<FormState>();

  bool get obscureText => _obscureText;

  set obscureText(bool newState) {
    _obscureText = newState;
    notifyListeners();
  }

  bool get firstTime => _firstTime;

  set firstTime(bool newState) {
    _firstTime = newState;
    notifyListeners();
  }

  bool get entrypoint => _entrypoint ?? false;

  set entrypoint(bool newState) {
    _entrypoint = newState;
    notifyListeners();
  }

  bool get loggedIn => _loggedIn ?? false;

  set loggedIn(bool newState) {
    _loggedIn = newState;
    notifyListeners();
  }

  getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    entrypoint = prefs.getBool('entrypoint') ?? false;
    loggedIn = prefs.getBool('loggedIn') ?? false;
  }

  bool validateAndSave() {
    final form = loginFormValue.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  bool profileValidation() {
    final form = profileFormValue.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  userLogin(LoginModel model) {
    AuthHelper.login(model).then((value) {
      if (value && firstTime) {
        Get.off(() => const PersonalDetails());
        firstTime = false;
      } else if (value && !firstTime) {
        Get.off(() => const MainScreen());
      } else {
        Get.snackbar(
          "Login Failed",
          "Please check your credentials",
          colorText: Color(kLight.value),
          backgroundColor: Colors.red,
          icon: const Icon(
            Icons.add_alert,
            color: Colors.white,
          ),
        );
      }
    });
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('loggedIn', false);
    await prefs.remove('token');
    await prefs.setBool('entrypoint', true);
    firstTime = false;
    loggedIn = false;
    entrypoint = true;

    print("firstTime: ${firstTime}");
    print("loggedIn: ${loggedIn}");
    notifyListeners();
  }

  updateProfile(ProfileUpdateReq model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString("id");

    AuthHelper.updateProfile(model, userId ?? '').then((response) {
      if (response) {
        Get.snackbar("Profile Updated", "Enjoy your search for a job",
            colorText: Color(kLight.value),
            backgroundColor: Color(kLightBlue.value),
            icon: const Icon(Icons.add_alert));

        Future.delayed(const Duration(seconds: 2)).then((value) {
          Get.off(() => const MainScreen());
        });
      } else {
        Get.snackbar(
          "Updating Failed",
          "Please try again",
          colorText: Color(kLight.value),
          backgroundColor: Color(kOrange.value),
          icon: const Icon(Icons.add_alert),
        );
      }
    });
  }
}
