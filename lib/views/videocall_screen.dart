import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();

class VideoConferencePage extends StatelessWidget {
  final String conferenceID;
  final String userName;
  final bool turnOnCam;

  const VideoConferencePage({
    Key? key,
    required this.conferenceID,
    required this.userName,
    required this.turnOnCam
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 983339814,
        appSign: "e072142196e65ccb7e36abf3b5a0352235b2dcd485a418be22c3c999de2c60c3",
        userID: localUserID,
        userName: userName,
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          turnOnCameraWhenJoining: turnOnCam,
        ),
      ),
    );
  }
}