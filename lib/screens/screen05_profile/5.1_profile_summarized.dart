import 'package:flutter/material.dart';
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;

import 'aux_profile_avatar.dart' show ProfileAvatar;

class ProfileSummarized extends StatelessWidget {
  final AppUserData appUserData;

  const ProfileSummarized({Key? key, required this.appUserData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 6.0),
        buildProfileAvatar(context),
        const SizedBox(height: 6.0),
        buildProfileName(context),
        const SizedBox(height: 6.0),
        buildProfileCard(context),
        const SizedBox(height: 12.0),
      ],
    );
  }

  Widget buildProfileAvatar(BuildContext context) => Center(
    child: ProfileAvatar(
      appUserData: this.appUserData,
      borderColor: Colors.transparent,
    ),
  );

  Widget buildProfileName(BuildContext context) => Center(
    child: Text(
      "${this.appUserData.firstName!} ${this.appUserData.lastName!}",
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
        fontSize: 20.0,
      ),
    ),
  );

  Widget buildProfileCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "@",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    this.appUserData.userName!,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 13.0,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Icon(
                        Icons.phone_android_rounded,
                        size: 13.0,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      "(${this.appUserData.phoneCountryDialCode!}) ${this.appUserData.phoneNumber!}",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(
                    Icons.email,
                    size: 13.0,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    this.appUserData.email,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 1.5),
                  child: Icon(
                    Icons.circle,
                    color: Colors.redAccent[700],
                    size: 13.0,
                  ),
                ),
                const SizedBox(width: 4.0),
                Text(
                  "Busy",
                  style: TextStyle(
                    color: Colors.redAccent[700],
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}