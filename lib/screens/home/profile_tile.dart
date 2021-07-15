import 'package:flutter/material.dart';
import 'package:jobee/models/profile.dart' show Profile;

class ProfileTile extends StatelessWidget {

  final Profile? job;

  const ProfileTile({ this.job });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 25.0,
            //backgroundImage: AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(job!.userName),
          subtitle: const Text('This job, located in ..., consists on ...'),
        ),
      ),
    );
  }
}