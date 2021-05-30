import 'package:flutter/material.dart';
import 'package:jobee/models/job.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/services/database.dart';
import 'package:provider/provider.dart';
import 'package:jobee/shared/constants.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: Container(),
        );
      });
    }

    return StreamProvider<List<Job>>.value(
      initialData: [],
      value: DatabaseService().jobs,
      child: Scaffold(
        backgroundColor: paletteColors["cream"],
        appBar: AppBar(
          title: Text(
            "Jobee",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: paletteColors["cream"],
          elevation: 1.0,
          actions: <Widget>[
            appBarTextIcon("Logout", Icons.person, Colors.black, () async {
              await _auth.signOut();
            }),
          appBarTextIcon("Logout", Icons.person, Colors.black, () async {
            _showSettingsPanel();
          }),
          ],
        ),
        body: Container(
          child: Container(
            // adadadada
          ),
        ),
      ),
    );
  }
}
