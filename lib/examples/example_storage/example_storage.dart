import 'dart:io' show File, Directory;
import 'dart:typed_data' show Uint8List;

import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:image_picker/image_picker.dart' show PickedFile, ImagePicker, ImageSource;

import 'save_as/save_as.dart' show saveAsBytes;

/// Enum representing the upload task types the example app supports.
enum UploadType {
  /// Uploads a randomly generated string (as a file) to Storage.
  string,

  /// Uploads a file from the device.
  file,

  /// Clears any tasks from the list.
  clear,
}

/// A StatefulWidget which keeps track of the current uploaded files.
class TaskManager extends StatefulWidget {
  // ignore: public_member_api_docs
  const TaskManager({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  List<UploadTask> _uploadTasks = <UploadTask>[];

  /// The user selects a file, and the task is added to the list.
  Future<UploadTask?> uploadFile(PickedFile? file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('playground')
        .child('/some-image.jpg');

    final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: <String, String>{'picked-file-path': file.path},
    );

    if (kIsWeb) {
      //debugPrint(ref);
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(file.path), metadata);
    }

    return Future<UploadTask>.value(uploadTask);
  }

  /// A new string is uploaded to storage.
  UploadTask uploadString() {
    const String putStringText =
        'This upload has been generated using the putString method! Check the metadata too!';

    // Create a Reference to the file
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('playground')
        .child('/put-string-example.txt');

    // Start upload of putString
    return ref.putString(putStringText,
        metadata: SettableMetadata(
            contentLanguage: 'en',
            customMetadata: <String, String>{'example': 'putString'}));
  }

  /// Handles the user pressing the PopupMenuItem item.
  Future<void> handleUploadType(UploadType type) async {
    switch (type) {
      case UploadType.string:
        _uploadTasks = <UploadTask>[..._uploadTasks, uploadString()];
        if (this.mounted) setState(() {});
        break;
      case UploadType.file:
        final PickedFile? file = await ImagePicker().getImage(source: ImageSource.gallery);

        final UploadTask? task = await uploadFile(file);

        if (task==null) break;
        _uploadTasks = <UploadTask>[..._uploadTasks, task];
        if (this.mounted) setState(() {});
        break;
      case UploadType.clear:
        setState(() {
          _uploadTasks = <UploadTask>[];
        });
        break;
    }
  }

  void _removeTaskAtIndex(int index) {
    setState(() {
      _uploadTasks.removeAt(index);
    });
  }

  Future<void> _downloadBytes(Reference ref) async {
    // download data
    final Uint8List? bytes = await ref.getData();
    if (bytes==null) return;

    // if we got bytes, save file
    await saveAsBytes(bytes, 'some-image.jpg');
  }

  Future<void> _downloadLink(Reference ref) async {
    final String link = await ref.getDownloadURL();

    await Clipboard.setData(ClipboardData(
      text: link,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Success!\n Copied download URL to Clipboard!',
        ),
      ),
    );
  }

  Future<void> _downloadFile(Reference ref) async {
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/temp-${ref.name}');
    if (tempFile.existsSync()) await tempFile.delete();

    await ref.writeToFile(tempFile);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
              'at path: ${ref.fullPath} \n'
              'Wrote "${ref.fullPath}" to tmp-${ref.name}.txt',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Example App'),
        actions: <PopupMenuButton<UploadType>>[
          PopupMenuButton<UploadType>(
            onSelected: handleUploadType,
            icon: const Icon(Icons.add),
            itemBuilder: (BuildContext context) => <PopupMenuItem<UploadType>>[
              const PopupMenuItem<UploadType>(
                // ignore: sort_child_properties_last
                child: Text('Upload string'),
                value: UploadType.string,
              ),
              const PopupMenuItem<UploadType>(
                // ignore: sort_child_properties_last
                child: Text('Upload local file'),
                value: UploadType.file,
              ),
              if (_uploadTasks.isNotEmpty)
                const PopupMenuItem<UploadType>(
                  // ignore: sort_child_properties_last
                  child: Text('Clear list'),
                  value: UploadType.clear,
                ),
            ],
          )
        ],
      ),
      body: _uploadTasks.isEmpty
      ? const Center(
        child: Text('Press the '+' button to add a new file.'),
      )
      : ListView.builder(
        itemCount: _uploadTasks.length,
        itemBuilder: (BuildContext context, int index) => UploadTaskListTile(
          task: _uploadTasks[index],
          onDismissed: () => _removeTaskAtIndex(index),
          onDownloadLink: () async {
            return _downloadLink(_uploadTasks[index].snapshot.ref);
          },
          onDownload: () async {
            if (kIsWeb) {
              return _downloadBytes(_uploadTasks[index].snapshot.ref);
            } else {
              return _downloadFile(_uploadTasks[index].snapshot.ref);
            }
          },
        ),
      ),
    );
  }
}

/// Displays the current state of a single UploadTask.
class UploadTaskListTile extends StatelessWidget {
  // ignore: public_member_api_docs
  const UploadTaskListTile({
    Key? key,
    required this.task,
    required this.onDismissed,
    required this.onDownload,
    required this.onDownloadLink,
  }) : super(key: key);

  /// The [UploadTask].
  final UploadTask /*!*/ task;

  /// Triggered when the user dismisses the task from the list.
  final VoidCallback /*!*/ onDismissed;

  /// Triggered when the user presses the download button on a completed upload task.
  final VoidCallback /*!*/ onDownload;

  /// Triggered when the user presses the 'link' button on a completed upload task.
  final VoidCallback /*!*/ onDownloadLink;

  /// Displays the current transferred bytes of the task.
  String _bytesTransferred(TaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalBytes}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (
          BuildContext context,
          AsyncSnapshot<TaskSnapshot> asyncSnapshot,
          ) {
        Widget subtitle = const Text('---');
        final TaskSnapshot? snapshot = asyncSnapshot.data;
        final TaskState? state = snapshot?.state;

        if (asyncSnapshot.hasError) {
          if (asyncSnapshot.error is FirebaseException &&
              (asyncSnapshot.error! as FirebaseException).code ==
                  'canceled') {
            subtitle = const Text('Upload canceled.');
          } else {
            // ignore: avoid_print
            debugPrint(asyncSnapshot.error.toString());
            subtitle = const Text('Something went wrong.');
          }
        } else if (snapshot != null) {
          subtitle = Text('$state: ${_bytesTransferred(snapshot)} bytes sent');
        }

        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (DismissDirection $) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (state == TaskState.running)
                  IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: task.pause,
                  ),
                if (state == TaskState.running)
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: task.cancel,
                  ),
                if (state == TaskState.paused)
                  IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: task.resume,
                  ),
                if (state == TaskState.success)
                  IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                if (state == TaskState.success)
                  IconButton(
                    icon: const Icon(Icons.link),
                    onPressed: onDownloadLink,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}