import 'package:flutter/material.dart';

import '../../../models/app_user.dart';
import '../../../views/conversation_screen.dart';
import '../../constants.dart';
import '../../utils/utils.dart';

class AllUserItem extends StatelessWidget {
  const AllUserItem({Key? key, required this.appUser}) : super(key: key);

  final AppUser appUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 15, right: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ConversationScreen(receiver: appUser)
              )
          );
        },
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.6),
              radius: 30,
              backgroundImage:
              appUser.photoUrl != null ? NetworkImage(appUser.photoUrl!) : null,
              child: appUser.photoUrl != null ? null :
              Text(
                  Utils.nameInit(appUser.displayName ?? ""),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 50,
                child: Text(
                  appUser.displayName!.length > 4 ? appUser.displayName!.substring(0, 4) : appUser.displayName!,
                  style: txtMedium(18),
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
