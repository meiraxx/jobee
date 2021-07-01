import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TextLoader extends StatefulWidget {
  final String? text;

  const TextLoader({Key? key, required String this.text}) : super(key: key);

  @override
  _TextLoaderState createState() => _TextLoaderState(text: text);
}

class _TextLoaderState extends State<TextLoader> {
  final String? text;

  _TextLoaderState({required this.text}) : super();

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
            text!,
            style: loadingTextStyle,
          ),
        ],
      ),
    );
  }
}
