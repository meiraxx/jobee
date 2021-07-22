import 'dart:async' show Completer;
//import 'package:flutter/foundation.dart' show debugPrint, FlutterError, FlutterErrorDetails, ErrorDescription, defaultTargetPlatform;
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' show ImageProvider, ImageConfiguration, ImageStream, ImageStreamListener, ImageInfo;
import 'package:flutter/services.dart' show rootBundle;

Future<void> loadImage(ImageProvider provider) {
  final ImageConfiguration config = ImageConfiguration(
    bundle: rootBundle,
    devicePixelRatio: 1,
    platform: defaultTargetPlatform,
  );
  final Completer<void> completer = Completer<void>();
  final ImageStream stream = provider.resolve(config);

  late final ImageStreamListener listener;

  listener = ImageStreamListener((ImageInfo image, bool sync) {
    debugPrint("Image ${image.debugLabel} finished loading");
    completer.complete();
    stream.removeListener(listener);
  }, onError: (Object exception, StackTrace? stackTrace) {
    completer.complete();
    stream.removeListener(listener);
    FlutterError.reportError(FlutterErrorDetails(
      context: ErrorDescription('image failed to load'),
      library: 'image resource service',
      exception: exception,
      stack: stackTrace,
      silent: true,
    ));
  });

  stream.addListener(listener);
  return completer.future;
}