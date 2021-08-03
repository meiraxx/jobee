import 'package:flutter/material.dart';

class HomeScreenBody extends StatefulWidget {
  final String page;

  const HomeScreenBody({Key? key, required this.page}) : super(key: key);

  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.page,
    );
  }
}