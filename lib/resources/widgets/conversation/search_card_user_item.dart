import 'package:flutter/material.dart';
import '../../../controllers/message_controller.dart';
import '../../../models/app_user.dart';
import '../../constants.dart';
import '../../utils/utils.dart';

class SearchCardUserItem extends StatelessWidget {
  const SearchCardUserItem({
    Key? key,
    required this.appUser,
    required this.user,
    required this.receiver,
    required this.chatRoomId,
  }) : super(key: key);
  final AppUser appUser;
  final AppUser user;
  final AppUser receiver;
  final String? chatRoomId;

  @override
  Widget build(BuildContext context) {
    MessageController m = MessageController(user: user, receiver: receiver, chatRoomId: chatRoomId);
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.withOpacity(0.6),
          radius: 23,
          backgroundImage: appUser.photoUrl != null ? NetworkImage(appUser.photoUrl!) : null,
          child: appUser.photoUrl != null ? null :
          Text(
              Utils.nameInit(appUser.displayName ?? ""),
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue
              )
          ),
        ),
        title: Text(
          appUser.displayName ?? "",
          style: txtMedium(18),
        ),
        subtitle: Text(
          Utils.userName(appUser.email ?? ""),
          style: txtRegular(14),
        ),
        onTap: () async {
          m.onSend(mess: appUser.uid!, type: "card");
          Navigator.pop(context);
        },
      ),
    );
  }
}
