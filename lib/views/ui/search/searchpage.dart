import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/models/response/jobs/jobs_response.dart';
import 'package:job_app/services/helpers/jobs_helper.dart';
import 'package:job_app/views/common/app_style.dart';
import 'package:job_app/views/common/loader.dart';
import 'package:job_app/views/common/reusable_text.dart';
import 'package:job_app/views/ui/jobs/widgets/job_tile.dart';
import 'package:job_app/views/ui/search/widgets/custom_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(kOrange.value),
        iconTheme: IconThemeData(color: Color(kLight.value)),
        title: CustomField(
          hintText: 'Search for a job',
          controller: search,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: const Icon(AntDesign.search1),
          ),
        ),
        elevation: 0,
      ),
      body: search.text.isNotEmpty
          ? FutureBuilder<List<JobsResponse>>(
              future: JobsHelper.searchJobs(search.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return const EmptyResultWidget(
                    text: "No job on your request",
                  );
                }
                var data = snapshot.data;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final job = data[index];
                    return VerticalTileWidget(job: job);
                  },
                );
              },
            )
          : const EmptyResultWidget(
              text: "Start Searching For Jobs",
            ),
    );
  }
}
