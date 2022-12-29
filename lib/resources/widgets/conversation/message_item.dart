import 'package:appchat/models/app_user.dart';
import 'package:appchat/resources/widgets/conversation/location_item.dart';
import 'package:appchat/resources/widgets/conversation/sticker_converstation_item.dart';
import 'package:appchat/resources/widgets/conversation/video_item.dart';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import 'card_user_item.dart';
import 'image_item.dart';
import 'mess_item.dart';
//ignore: must_be_immutable
class MessageItem extends StatelessWidget {
  MessageItem({
    Key? key,
    required this.message,
    required this.isMe,
    required this.isMidle,
    required this.isLast,
    this.appUser
  }) : super(key: key);

  final Message message;
  final bool isMe;
  final bool isMidle;
  final bool isLast;
  AppUser? appUser;

  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case "message":
        return MessItem(
          isMe: isMe,
          isMidle: isMidle,
          isLast: isLast,
          message: message.message ?? ""
        );
      case "image":
        return ImageItem(isMe: isMe, medias: message.medias ?? []);
      case "sticker":
        return StickerConverstationItem(isMe: isMe, medias: message.medias ?? []);
      case "video":
        return VideoItem(
          message: message,
          isMe: isMe,
        );
      case "card":
        return CardUserItem(
          isMe: isMe,
          isMidle: isMidle,
          isLast: isLast,
          appUser: appUser!,
        );
      case "location":
        return LocationItem(
            isMe: isMe,
            isMidle: isMidle,
            isLast: isLast,
            message: message,
        );
      default:
        return Container();
    }
  }
}
