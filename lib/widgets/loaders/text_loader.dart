import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitChasingDots;
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

class TextLoader extends StatefulWidget {
  final String? text;

  const TextLoader({Key? key, required String this.text}) : super(key: key);

  @override
  _TextLoaderState createState() => _TextLoaderState();
}

class _TextLoaderState extends State<TextLoader> {

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    const double loaderSize = 70.0;
    const double loaderRadius = loaderSize/2;
    const double spacing = 12.0;
    final TextStyle loadingTextStyle = GoogleFonts.montserrat(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w600,
      fontSize: 24.0,
    );

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        padding: EdgeInsets.only(
          top: queryData.size.height/2 - (loaderRadius + spacing + loadingTextStyle.fontSize!),
        ),
        child: Column(
          children: <Widget>[
            Center(
              child: SpinKitChasingDots(
                color: Theme.of(context).colorScheme.primary,
                duration: const Duration(seconds: 1),
                size: loaderSize,
              ),
            ),
            const SizedBox(height: spacing),
            Text(
              widget.text!,
              style: loadingTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}