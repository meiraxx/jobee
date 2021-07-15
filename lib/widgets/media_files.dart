import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart' show CupertinoActionSheet, CupertinoActionSheetAction, showCupertinoModalPopup;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


Future<PickedFile?> _getImageFromSource(ImageSource imageSource) async {
  final ImagePicker picker = ImagePicker();
  final PickedFile? pickedImage = await picker.getImage(source: imageSource);

  return pickedImage;
}

Future<PickedFile?> showImageSourceActionSheet(BuildContext context) async {
  PickedFile? pickedImage;
  Future<dynamic> userActionsFuture;

  // TODO and TODO-BackEnd: implement image upload maximum bytes
  if (Platform.isIOS) {
    userActionsFuture = showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () async {
              pickedImage = await _getImageFromSource(ImageSource.camera);
              Navigator.pop(context);
            },
            child: const Text("Take a photo"),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              pickedImage = await _getImageFromSource(ImageSource.gallery);
              Navigator.pop(context);
            },
            child: const Text("Pick from gallery"),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              // TODO: implement remove image
              Navigator.pop(context);
            },
            child: const Text("Remove image"),
          ),
        ],
      ),
    );
  } else {
    userActionsFuture = showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Wrap(children: <Widget>[
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text("Take a photo"),
          onTap: () async {
            pickedImage = await _getImageFromSource(ImageSource.camera);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text("Pick from gallery"),
          onTap: () async {
            pickedImage = await _getImageFromSource(ImageSource.gallery);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text("Remove image"),
          onTap: () async {
            // TODO: implement remove image
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



