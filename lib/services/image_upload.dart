import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> getImage() async {
  final picker = ImagePicker();
  final PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);

  if (pickedFile==null) return null;

  final File _image = File(pickedFile.path);

  return _image;
}