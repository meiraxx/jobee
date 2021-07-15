import 'package:flutter/material.dart';

class SizeProviderWidget extends StatefulWidget {
  final Widget child;
  final Function(Size) onChildSize;

  const SizeProviderWidget({Key? key, required this.onChildSize, required this.child})
      : super(key: key);
  @override
  _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
}

class _SizeProviderWidgetState extends State<SizeProviderWidget> {
  /// Class to be used for retrieving widget sizes:
  /// - Useful for debugging sizes
  /// - Useful for calculating new sizes
  ///
  /// Note: if needed, wrap the SizeProviderWidget with an OrientationBuilder widget
  /// to make it respect the orientation of the device

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((Duration timeStamp) {
      widget.onChildSize(context.size!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}