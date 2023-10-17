import 'dart:convert';

import 'package:job_app/models/response/jobs/jobs_response.dart';

List<AllBookmarks> allBookmarksFromJson(String str) => List<AllBookmarks>.from(
    json.decode(str).map((x) => AllBookmarks.fromJson(x)));

class AllBookmarks {
  final String id;
  final JobsResponse job;

  AllBookmarks({
    required this.id,
    required this.job,
  });

  factory AllBookmarks.fromJson(Map<String, dynamic> json) => AllBookmarks(
        id: json["_id"],
        job: JobsResponse.fromJson(json["job"]),
      );
}
