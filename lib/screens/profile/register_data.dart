import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart';
import 'package:jobee/screens/home/home.dart';
import 'package:jobee/screens/shared/logo.dart';
import 'package:jobee/shared/constants.dart';
import 'package:provider/provider.dart';

class RegisterData extends StatefulWidget {
  const RegisterData({Key? key}) : super(key: key);

  @override
  _RegisterDataState createState() => _RegisterDataState();
}

class _RegisterDataState extends State<RegisterData> {
  bool hasRegisteredUserData = false;
  // Form constants
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<AppUserData>(context).email);

    return hasRegisteredUserData
      ?Home()
      :Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: paletteColors["cream"],
      appBar: AppBar(
        backgroundColor: paletteColors["cream"],
        elevation: 1.0,
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Logo(),
            SizedBox(width: 16.0),
            Text(
              "|   Personal information",
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        )
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: Text(
              "This information will be part of your public profile",
              style: TextStyle(
                color: paletteColors["brown"],
                fontSize: 18.0,
                fontWeight: FontWeight.w400
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                ],
              ),
            ),
          ),
          SizedBox(height: 260.0),
        ],
      ),
    );
  }
}
