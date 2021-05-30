import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    // return either Authenticate or Home widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
