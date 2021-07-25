import 'package:flutter/material.dart';

class InPlaceLoader extends StatelessWidget {
  final Size baseSize;
  final Size correctionSize;
  final EdgeInsets padding;

  const InPlaceLoader({Key? key, required this.baseSize, this.padding = EdgeInsets.zero, this.correctionSize = const Size(0.0, 0.0)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: baseSize.width - correctionSize.width,
        height: baseSize.height - correctionSize.height,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  // waiting 1-3 seconds showing the loading widget animation is recommended because it looks neater than an almost-instant animation
  static Future<void> extendLoadingDuration(Duration duration) async => Future<void>.delayed(duration);
}