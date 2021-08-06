import 'package:flutter/material.dart';
import 'package:jobee/screens/widgets/buttons/app_bar_button.dart' show appBarButton;

class JobeeServiceList extends StatefulWidget {
  const JobeeServiceList({Key? key}) : super(key: key);

  @override
  _JobeeServiceListState createState() => _JobeeServiceListState();
}

class _JobeeServiceListState extends State<JobeeServiceList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: appBarButton(context: context, iconData: Icons.arrow_back, onClicked: () {
          Navigator.pop(context);
        }),
        //backgroundColor: Theme.of(context).backgroundColor,
        title: const Text("Services"),
      ),
      body: const SizedBox(),
      //bottomNavigationBar: bottomNavigationBar,
    );
  }
}
