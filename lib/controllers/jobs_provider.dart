import 'package:flutter/foundation.dart';
import 'package:job_app/models/response/jobs/get_job.dart';
import 'package:job_app/models/response/jobs/jobs_response.dart';
import 'package:job_app/services/helpers/jobs_helper.dart';

class JobsNotifier extends ChangeNotifier {
  late Future<List<JobsResponse>> jobList;
  late Future<JobsResponse> recentJob;
  late Future<GetJobRes> job;

  getJobs() {
    jobList = JobsHelper.getJobs();
  }

  getJob(String id) {
    job = JobsHelper.getJob(id);
  }

  getRecentJob() {
    recentJob = JobsHelper.getRecentJob();
  }
}
