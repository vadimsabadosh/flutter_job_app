import 'dart:convert';

import 'package:http/http.dart' as https;
import 'package:job_app/models/response/jobs/get_job.dart';
import 'package:job_app/models/response/jobs/jobs_response.dart';
import 'package:job_app/services/config.dart';

class JobsHelper {
  static var client = https.Client();

  static Future<List<JobsResponse>> getJobs() async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiUrl, Config.jobs);
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      List<JobsResponse> jobs = jobsResponseFromJson(response.body);
      return jobs;
    } else {
      print(response.body.toString());
      throw Exception("Failed to get jobs");
    }
  }

  static Future<GetJobRes> getJob(String id) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiUrl, "${Config.jobs}/$id");
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      GetJobRes job = getJobResFromJson(response.body);
      return job;
    } else {
      throw Exception("Failed to get job");
    }
  }

  static Future<JobsResponse> getRecentJob() async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiUrl, Config.recentJob);
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      JobsResponse job = JobsResponse.fromJson(json.decode(response.body));
      return job;
    } else {
      throw Exception("Failed to get jobs");
    }
  }

  // search

  static Future<List<JobsResponse>> searchJobs(String search) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiUrl, "${Config.search}/$search");
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      List<JobsResponse> jobs = jobsResponseFromJson(response.body);
      return jobs;
    } else {
      throw Exception("Failed to search jobs");
    }
  }
}
