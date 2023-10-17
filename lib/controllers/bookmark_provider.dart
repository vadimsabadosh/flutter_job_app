import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/models/response/bookmarks/all_bookmarks.dart';
import 'package:job_app/services/helpers/book_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkNotifier extends ChangeNotifier {
  List<String> _jobs = [];

  late Future<List<AllBookmarks>> bookmarks;

  List<String> get jobs => _jobs;

  set jobs(List<String> newList) {
    _jobs = newList;
    notifyListeners();
  }

  Future<void> addJob(String jobId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _jobs.insert(0, jobId);
    prefs.setStringList("jobIds", _jobs);
    notifyListeners();
  }

  Future<void> removeJob(String jobId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _jobs.remove(jobId);
    prefs.setStringList("jobIds", _jobs);
    notifyListeners();
  }

  Future<void> loadJob() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobs = prefs.getStringList('jobIds');
    if (jobs != null) {
      _jobs = jobs;
    }
  }

  addBookmark(String id) {
    BookMarkHelper.addBookmarks(id).then((response) {
      if (response) {
        addJob(id);
        Get.snackbar(
          "Bookmark successfully added",
          "Please check your bookmarks",
          colorText: Color(kLight.value),
          backgroundColor: Color(kLightBlue.value),
          icon: const Icon(Icons.bookmark_add_outlined),
        );
      } else {
        Get.snackbar(
          "Failed to add bookmarks",
          "Please try again",
          colorText: Color(kLight.value),
          backgroundColor: Color(kOrange.value),
          icon: const Icon(Icons.bookmark_add_outlined),
        );
      }
    });
  }

  removeBookmark(String id) {
    BookMarkHelper.removeBookmarks(id).then((response) {
      if (response) {
        removeJob(id);
        Get.snackbar(
          "Bookmark successfully deleted",
          "",
          colorText: Color(kLight.value),
          backgroundColor: Color(kLightBlue.value),
          icon: const Icon(Icons.bookmark_remove_outlined),
        );
      } else {
        Get.snackbar(
          "Failed to delete bookmarks",
          "Please try again",
          colorText: Color(kLight.value),
          backgroundColor: Color(kOrange.value),
          icon: const Icon(Icons.bookmark_remove_outlined),
        );
      }
    });
  }

  getAllBookmarks() {
    bookmarks = BookMarkHelper.getAllBookmarks();
  }
}
