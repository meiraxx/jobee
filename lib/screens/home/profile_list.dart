import 'package:jobee/models/profile.dart';
import 'package:jobee/screens/home/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileList extends StatefulWidget {

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
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