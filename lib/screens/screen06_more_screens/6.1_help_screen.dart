import 'package:flutter/material.dart';
import 'package:jobee/screens/widgets/buttons/app_bar_button.dart' show appBarButton;

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: appBarButton(context: context, iconData: Icons.arrow_back, onClicked: () {
          Navigator.pop(context);
        }),
        //backgroundColor: Theme.of(context).backgroundColor,
        title: const Text("Help"),
      ),
      body: const SizedBox(),
      //bottomNavigationBar: bottomNavigationBar,
    );
  }
}
