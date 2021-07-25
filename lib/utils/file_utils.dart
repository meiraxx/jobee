import 'dart:io';
import 'dart:typed_data' show Uint8List;

void createFileRecursivelyAndWriteBytesSync(File localFile, Uint8List bytes) {
  // createSync creates a file and all required directories (if any file or dir already exists, these are left untouched)
  localFile.createSync(recursive: true);
  // write to local file
  localFile.writeAsBytesSync(bytes);
}