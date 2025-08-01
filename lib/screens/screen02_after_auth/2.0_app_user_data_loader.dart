import 'package:flutter/material.dart';
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;
import 'package:jobee/services/service01_database/1.0_database.dart' show DatabaseService;
import 'package:jobee/screens/widgets/loaders/text_loader.dart' show TextLoader;
import 'package:jobee/services/service03_storage/3.0_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '2.1_after_auth_wrapper.dart' show AfterAuthWrapper;

class AppUserDataLoader extends StatefulWidget {
  final DatabaseService userDatabaseService;

  const AppUserDataLoader({Key? key, required this.userDatabaseService}) : super(key: key);

  @override
  _AppUserDataLoaderState createState() => _AppUserDataLoaderState();
}

class _AppUserDataLoaderState extends State<AppUserDataLoader> {
  /// future used to store userDatabaseService.initialAppUserDataFuture getter result
  Future<AppUserData>? _initialAppUserDataFuture;

  @override
  void initState() {
    _initialAppUserDataFuture = widget.userDatabaseService.getInitialAppUserDataFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AppUserData FutureBuilder
    return FutureBuilder<AppUserData>(
        future: _initialAppUserDataFuture,
        builder: (BuildContext context, AsyncSnapshot<AppUserData> futureAppUserDataSnapshot) {
          if (futureAppUserDataSnapshot.connectionState == ConnectionState.waiting) {
            return const TextLoader(text: "Loading user information...");
          }

          if (futureAppUserDataSnapshot.connectionState == ConnectionState.done) {
            if (futureAppUserDataSnapshot.hasError) {
              return Text('Error: ${futureAppUserDataSnapshot.error}');
            }

            // at this point, futureAppUserDataSnapshot.data should not be null
            assert(futureAppUserDataSnapshot.data != null);

            // Initialize storageService based on uid
            storageService = StorageService(uid: futureAppUserDataSnapshot.data!.uid);

            // Authenticated MultiProvider
            return MultiProvider(
              // Authenticated providers
              providers: <SingleChildWidget>[
                StreamProvider<AppUserData>.value(initialData: futureAppUserDataSnapshot.data!, value: widget.userDatabaseService.appUserData),
              ],
              child: const AfterAuthWrapper(),
            );
          }
          // this code should not be reached
          throw Exception("Error: This code shouldn't ever be reached.");
        }
    );
  }
}