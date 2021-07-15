import 'package:flutter/material.dart';
import 'package:jobee/models/profile.dart' show Profile;
import 'package:jobee/screens/home/profile_tile.dart' show ProfileTile;
import 'package:provider/provider.dart' show Provider;

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
      itemBuilder: (BuildContext context, int index) {
        return ProfileTile(job: profiles[index]);
      },
    );
  }
}