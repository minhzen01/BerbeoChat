import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../controllers/firebase_auth_controller.dart';
import '../resources/constants.dart';
import '../resources/utils/utils.dart';
import '../resources/widgets/auth/auth_button.dart';
import '../resources/widgets/change_profile/header_edit.dart';

class ChangeProfileScreen extends StatefulWidget {
  const ChangeProfileScreen({Key? key}) : super(key: key);

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  TextEditingController? nameController;
  TextEditingController? passController;
  File? avatarImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(
        text: context.read<FirebaseAuthController>().appUser!.displayName);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<FirebaseAuthController>().appUser;
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
              child: Column(
                children: [
                  const HeaderEdit(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          GestureDetector(
                              onTap: () {
                                Utils.showPickImageModelBottomSheet(context, onPickImage: (image) {
                                  setState(() {
                                    avatarImage = image;
                                  });
                                  Navigator.pop(context);
                                });
                              },
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  avatarImage != null ?
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(avatarImage!),
                                  ) :
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey.withOpacity(0.6),
                                    backgroundImage: user!.photoUrl != null ?
                                    NetworkImage(user.photoUrl!) : null,
                                    child: user.photoUrl != null ? null :
                                    Text(
                                      Utils.nameInit(user.displayName ?? ""),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue
                                      )
                                    ),
                                ),
                                  SvgPicture.asset(
                                    editIcon,
                                    color: primaryColor,
                                    width: 24,
                                    height: 24,
                                  )
                                ],
                              )
                          ),
                          const SizedBox(height: 5),
                          Text(
                            Utils.userName(context.read<FirebaseAuthController>().appUser!.email ?? "",),
                            style: txtMedium(12),
                          ),
                          const SizedBox(height: 24,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Name",
                              style: txtSemiBold(18),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: nameController,
                            style: txtMedium(18),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                hintText: "Name",
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    editIcon,
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                        //prefixIcon: SizedBox(width: 24),
                                border: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: secondaryColor, width: 0.5)
                                )
                            ),
                          ),
                          const SizedBox(height: 42),
                          AuthButton(
                              title: "Update",
                              onTap: () async {
                                await context.read<FirebaseAuthController>().updateUser(
                                displayName: nameController!.text,
                                avatar: avatarImage
                                ).then((value) {
                                  if (value) {
                                    Navigator.pop(context);
                                  }
                                });
                              }
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
          )
        ),
        if (context.watch<FirebaseAuthController>().isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}
