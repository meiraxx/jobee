import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart' show CupertinoActionSheet, CupertinoActionSheetAction, showCupertinoModalPopup;
import 'dart:io' show File, Platform;


Future<PickedFile?> _getImageFromSource(ImageSource imageSource) async {
  final ImagePicker picker = ImagePicker();
  final PickedFile? pickedImage = await picker.getImage(source: imageSource);

  return pickedImage;
}

Future<PickedFile?> showImageSourceActionSheet(BuildContext context) async {
  PickedFile? pickedImage;
  Future userActionsFuture;

  if (Platform.isIOS) {
    userActionsFuture = showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () async {
              Navigator.pop(context);
              pickedImage = await _getImageFromSource(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Gallery'),
            onPressed: () async {
              Navigator.pop(context);
              pickedImage = await _getImageFromSource(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  } else {
    userActionsFuture = showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(children: [
        ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text('Camera'),
          onTap: () async {
            pickedImage = await _getImageFromSource(ImageSource.camera);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.photo_album),
          title: Text('Gallery'),
          onTap: () async {
            pickedImage = await _getImageFromSource(ImageSource.gallery);
            Navigator.pop(context);
          },
        ),
      ]),
    );
  }

  // awaits for completion of the user interaction with the modal widget.
  // ... either of the following events are possible:
  // 1. User picked an image (the picked image is returned)
  // 2. User canceled (null is returned)
  await userActionsFuture;

  return pickedImage;
}



