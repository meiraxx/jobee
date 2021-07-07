import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InPlaceLoader extends StatelessWidget {
  final Size replacedWidgetSize;
  final double submissionErrorHeight;

  const InPlaceLoader({Key? key, required this.replacedWidgetSize, required this.submissionErrorHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: submissionErrorHeight),
      child: SizedBox(
        height: replacedWidgetSize.height - submissionErrorHeight*2,
        width: replacedWidgetSize.width - submissionErrorHeight*2,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  // waiting 1-3 seconds showing the loading widget animation is recommended because
  // it looks neater than an almost-instant animation
  static Future<void> minimumLoadingSleep(Duration duration) async => await Future.delayed(duration);
}

class TextLoader extends StatefulWidget {
  final String? text;

  const TextLoader({Key? key, required String this.text}) : super(key: key);

  @override
  _TextLoaderState createState() => _TextLoaderState();
}

class _TextLoaderState extends State<TextLoader> {

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double loaderRadius = 25.0;
    double spacing = 12.0;
    TextStyle loadingTextStyle = Theme.of(context).textTheme.headline4!;

    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.only(
        top: queryData.size.height/2 - (loaderRadius + spacing + loadingTextStyle.fontSize!),
      ),
      child: Column(
        children: [
          Center(
            child: SpinKitChasingDots(
              color: Theme.of(context).colorScheme.primary,
              size: loaderRadius*2,
              duration: Duration(seconds: 1),
            ),
          ),
          SizedBox(height: spacing),
          Text(
            widget.text!,
            style: loadingTextStyle,
          ),
        ],
      ),
    );
  }
}