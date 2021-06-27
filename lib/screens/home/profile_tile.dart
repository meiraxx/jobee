import 'package:flutter/material.dart';
import 'package:jobee/models/profile.dart';

class ProfileTile extends StatelessWidget {

  final Profile? job;

  ProfileTile({ this.job });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(job!.userName),
          subtitle: Text('This job, located in ..., consists on ...'),
        ),
      ),
    );
  }
}