import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart' show CupertinoActionSheet, CupertinoActionSheetAction, showCupertinoModalPopup;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobee/services/service03_storage/3.0_storage.dart';


Future<PickedFile?> _getImageFromSource(ImageSource imageSource) async {
  final ImagePicker picker = ImagePicker();

  // TODO: enforce a circular cut of the uploaded image with dynamic width/height smaller than maxWidth/maxHeight
  final PickedFile? pickedImage = await picker.getImage(
    source: imageSource,
    maxHeight: 1024,
    maxWidth: 1024,
  );
  // TODO: enforce that the cut image occupies a maximum memory size (in bytes, e.g. 2 MB)
  // TODO-BackEnd: enforce that the uploaded cut image occupies a maximum memory size (in bytes, e.g. 2 MB)
  // TODO: enforce that the cut image has width == height (e.g., 1024x1024)
  // TODO-BackEnd: enforce that the uploaded cut image has width == height (e.g., 1024x1024)
  // TODO: enforce that the cut image has maxWidth/maxHeight (e.g., 1024)
  // TODO-BackEnd: enforce that the uploaded cut image has maxWidth/maxHeight (e.g., 1024)

  return pickedImage;
}

Future<PickedFile?> showProfileImageActionSheet(BuildContext context, {Function()? onRemoveImageClicked}) async {
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
          if (onRemoveImageClicked != null) ... <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: onRemoveImageClicked,
              child: const Text("Remove image"),
            )
          ],
        ],
      ),
    );
  } else {
    userActionsFuture = showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Wrap(children: <Widget>[
        ListTile(
          leading: Icon(Icons.camera_alt_outlined, color: Theme.of(context).colorScheme.onBackground),
          title: const Text("Take a photo"),
          onTap: () async {
            pickedImage = await _getImageFromSource(ImageSource.camera);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.image_outlined, color: Theme.of(context).colorScheme.onBackground),
          title: const Text("Pick from gallery"),
          onTap: () async {
            pickedImage = await _getImageFromSource(ImageSource.gallery);
            Navigator.pop(context);
          },
        ),
        if (onRemoveImageClicked != null) ... <ListTile>[
          ListTile(
            leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.onBackground),
            title: const Text("Remove image"),
            onTap: onRemoveImageClicked,
          ),
        ],
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



