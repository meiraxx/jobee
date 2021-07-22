import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/screens/package4_profile/profile_avatar.dart' show ProfileAvatar;

class ProfileSummarized extends StatefulWidget {
  final AppUserData? appUserData;

  const ProfileSummarized({Key? key, required this.appUserData}) : super(key: key);

  @override
  _ProfileSummarizedState createState() => _ProfileSummarizedState();
}

class _ProfileSummarizedState extends State<ProfileSummarized> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 6.0),
        Center(
          child: ProfileAvatar(
            appUserData: widget.appUserData!,
            borderColor: Theme.of(context).colorScheme.primary,
            isHero: false,
          ),
        ),
        const SizedBox(height: 6.0),
        Center(
          child: Text(
            "${widget.appUserData!.firstName!} ${widget.appUserData!.lastName!}",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontSize: 20.0,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Card(
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
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        widget.appUserData!.userName!,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Icon(
                            Icons.phone_android_rounded,
                            size: 13.0,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          "(${widget.appUserData!.phoneCountryDialCode!}) ${widget.appUserData!.phoneNumber!}",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Icon(
                        Icons.email,
                        size: 13.0,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        widget.appUserData!.email,
                        style: Theme.of(context).textTheme.bodyText2,
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
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}