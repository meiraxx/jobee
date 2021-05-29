import 'package:flutter/material.dart';
import 'package:jobee/models/job.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/services/database.dart';
import 'package:provider/provider.dart';

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
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text("jobee"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.person,
                color: Colors.limeAccent[100],
              ),
              label: Text(
                "Logout",
                style: TextStyle(color: Colors.limeAccent[100]),
              ),
              onPressed: () async {
                await _auth.signOut();
                print("User logged out.");
              },
            ),
            TextButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: Icon(
                  Icons.settings,
                  color: Colors.limeAccent[100],
                ),
                label: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.limeAccent[100],
                  ),
                ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/net-honeycomb-pattern.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(

          ),
        ),
      ),
    );
  }
}
