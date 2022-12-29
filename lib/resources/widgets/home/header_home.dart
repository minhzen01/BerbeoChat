import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../controllers/firebase_auth_controller.dart';
import '../../../models/app_user.dart';
import '../../../views/change_profile_screen.dart';
import '../../constants.dart';
import '../../utils/utils.dart';

class HeaderHome extends StatefulWidget {
  const HeaderHome({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  State<HeaderHome> createState() => _HeaderHomeState();
}

class _HeaderHomeState extends State<HeaderHome> {
  File? avatarImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          amzChatIcon,
          width: 25,
          height: 25,
        ),
        GestureDetector(
            onTap: () {
              Utils.showPickImageModelBottomSheet(
                context,
                onPickImage: (image) {
                  setState(() async {
                    avatarImage = image;
                    await context
                        .read<FirebaseAuthController>()
                        .updateUser(
                        displayName: widget.user.displayName!,
                        avatar: avatarImage).then((value) {
                      if (value) {
                        Navigator.pop(context);
                      }
                    });
                  });
                  Navigator.pop(context);
                },
              );
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                avatarImage != null ?
                CircleAvatar(
                  radius: 25,
                  backgroundImage: FileImage(avatarImage!),
                ) :
                CircleAvatar(
                  radius: 25,
                  backgroundColor:
                  Colors.grey.withOpacity(0.6),
                  backgroundImage: widget.user.photoUrl != null ?
                  NetworkImage(widget.user.photoUrl!) : null,
                  child: widget.user.photoUrl != null ? null :
                  Text(
                    Utils.nameInit(widget.user.displayName ?? ""),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                    )
                  ),
                ),
              ],
            )
        ),
        PopupMenuButton<int>(
          offset: const Offset(0, 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onSelected: (val) {
            if (val == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChangeProfileScreen()
                  )
              );
            } else {
              context.read<FirebaseAuthController>().signOut();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 0,
                child: ListTile(
                  leading: SvgPicture.asset(
                    editIcon,
                    height: 24,
                    width: 24,
                  ),
                  title: const Text("Edit Profile"),
                )),
            PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: SvgPicture.asset(
                    signOutIcon,
                    height: 24,
                    width: 24,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                )
            ),
          ],
          child: SvgPicture.asset(
            optionIcon,
            height: 24,
            width: 24,
            color: primaryColor,
          ),
        )
      ],
    );
  }
}
