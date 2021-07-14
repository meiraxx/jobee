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
            child: Text('Take a photo'),
            onPressed: () async {
              pickedImage = await _getImageFromSource(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Pick from gallery'),
            onPressed: () async {
              pickedImage = await _getImageFromSource(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Remove image"),
            onPressed: () async {
              Navigator.pop(context);
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
          title: Text('Take a photo'),
          onTap: () async {
            pickedImage = await _getImageFromSource(ImageSource.camera);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text('Pick from gallery'),
          onTap: () async {
            pickedImage = await _getImageFromSource(ImageSource.gallery);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text("Remove image"),
          onTap: () async {
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



