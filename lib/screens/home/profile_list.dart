import 'package:jobee/models/profile.dart';
import 'package:jobee/screens/home/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobList extends StatefulWidget {

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  @override
  Widget build(BuildContext context) {

    final List<Profile> profiles = Provider.of<List<Profile>>(context);

    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        return ProfileTile(job: profiles[index]);
      },
    );
  }
}
