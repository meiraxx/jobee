 import 'package:jobee/models/job.dart';
import 'package:jobee/screens/home/job_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobList extends StatefulWidget {

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  @override
  Widget build(BuildContext context) {

    final List<Job> jobs = Provider.of<List<Job>>(context) ?? [];

    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        return JobTile(job: jobs[index]);
      },
    );
  }
}
