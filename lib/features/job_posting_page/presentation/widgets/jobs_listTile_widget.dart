import 'package:flutter/material.dart';
import 'package:iccmw/features/job_posting_page/presentation/pages/job_detail_page.dart';

class JobsListtileWidget extends StatefulWidget {
  final String JobTitle;
  final int JobId;
  const JobsListtileWidget(
      {super.key, required this.JobTitle, required this.JobId});

  @override
  State<JobsListtileWidget> createState() => _JobsListtileWidgetState();
}

class _JobsListtileWidgetState extends State<JobsListtileWidget> {
  void _handleTileTap() {
    // Navigate to the JobDetailPage when the tile is tapped
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => jobDetailPage(jobId: widget.JobId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12), // Set the radius value
      ),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: ListTile(
        title: Text(
          widget.JobTitle,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
        ),
        onTap: _handleTileTap,
      ),
    );
  }
}
