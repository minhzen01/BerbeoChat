import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/firebase_auth_controller.dart';
import '../../../models/app_user.dart';
import '../../../views/conversation_screen.dart';
import '../../constants.dart';
import '../../utils/utils.dart';

class CardUserItem extends StatefulWidget {
  const CardUserItem({
    Key? key,
    required this.isMe,
    required this.isMidle,
    required this.isLast,
    required this.appUser
  }) : super(key: key);
  final bool isMe;
  final bool isMidle;
  final bool isLast;
  final AppUser appUser;


  @override
  State<CardUserItem> createState() => _CardUserItemState();
}

class _CardUserItemState extends State<CardUserItem> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthController>().appUser!;
    return widget.appUser == user ?
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.lightBlue.withOpacity(.85),
                    borderRadius: messageBorderRadius(widget.isMe, widget.isMidle, widget.isLast)
                ),
                child: Center(
                  child: Text(
                    "Danh thiếp",
                    style: txtMedium(18, Colors.white),
                    softWrap: true,
                  ),
                )
            ),
          ],
        ),
      ) :
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(.85),
                  borderRadius: messageBorderRadius(widget.isMe, widget.isMidle, widget.isLast)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.6),
                      radius: 25,
                      backgroundImage: widget.appUser.photoUrl != null ? NetworkImage(widget.appUser.photoUrl!) : null,
                      child: widget.appUser.photoUrl != null ? null :
                      Text(
                          Utils.nameInit(widget.appUser.displayName ?? ""),
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue
                          )
                      ),
                    ),
                    title: Text(
                      widget.appUser.displayName ?? "",
                      style: txtMedium(18, Colors.white),
                      softWrap: true,
                    ),
                    subtitle: Text(
                      Utils.userName(widget.appUser.email ?? ""),
                      style: txtRegular(14, Colors.white),
                      softWrap: true,
                    ),
                    onTap: () {
                    },
                  ),
                  Center(
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ConversationScreen(receiver: widget.appUser)
                              )
                          );
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                        child: const Text(
                          "Nhắn tin",
                          style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      );
  }

  EdgeInsetsGeometry paddingItem() {
    if (widget.isMidle) {
      return const EdgeInsets.symmetric(vertical: 1, horizontal: 16);
    }
    if (widget.isLast) {
      return const EdgeInsets.only(bottom: 1, top: 8, left: 16, right: 16);
    }
    return const EdgeInsets.only(top: 1, left: 16, right: 16);
  }

  BorderRadiusGeometry messageBorderRadius(
      bool isMe, bool isMidle, bool isLast) {
    if (isMe) {
      if (isMidle) {
        return const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)
        );
      }
      if (isLast) {
        return const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)
        );
      }
      return const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
      );
    } else {
      if (isMidle) {
        return const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)
        );
      }
      if (isLast) {
        return const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)
        );
      }
      return const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
      );
    }
  }
}
