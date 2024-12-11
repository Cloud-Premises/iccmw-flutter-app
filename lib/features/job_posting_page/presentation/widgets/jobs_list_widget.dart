import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:iccmw/features/job_posting_page/presentation/widgets/jobs_listTile_widget.dart';

class JobsListWidget extends StatefulWidget {
  const JobsListWidget({super.key});

  @override
  State<JobsListWidget> createState() => _JobsListWidgetState();
}

class _JobsListWidgetState extends State<JobsListWidget> {
  List<Map<String, dynamic>> Jobs = [];
  bool isLoading = true;
  List<Map<String, dynamic>> JobsStatus = [];
  bool isJobListEmpty = true;
  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    final url =
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/jobPostingPage/jobPostingPage.json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final JobsList = jsonData['jobPosting'] as List;

        setState(() {
          if (!JobsList.isEmpty) {
            isJobListEmpty == false;
          }

          JobsStatus = jsonData['jobPosting'];

          Jobs = JobsList.map((Job) => {'id': Job['id'], 'title': Job['title']})
              .toList();
          isLoading = false;
        });
      } else {
        print('Failed to load Jobs');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching Jobs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchJobs, // Call fetchJobs when refreshing
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Job Posting',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              isJobListEmpty
                  ? Center(
                      child: Text('No Jobs Available'),
                    )
                  : isLoading
                      ? buildShimmerLoading()
                      : buildJobsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildShimmerLoading() {
    return Column(
      children: List.generate(5, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 50.0,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }

  Widget buildJobsList() {
    return Column(
      children: Jobs.map((Job) => JobsListtileWidget(
            JobTitle: Job['title'],
            JobId: Job['id'],
          )).toList(),
    );
  }
}
