import 'package:appchat/resources/widgets/conversation/search_card_user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/firebase_auth_controller.dart';
import '../controllers/search_controller.dart';
import '../models/app_user.dart';
import '../resources/constants.dart';
import '../resources/widgets/search/header_search.dart';

class SearchCardUserScreen extends StatefulWidget {
  const SearchCardUserScreen({
    Key? key,
    required this.user,
    required this.receiver,
    required this.chatRoomId,
  }) : super(key: key);
  final AppUser user;
  final AppUser receiver;
  final String? chatRoomId;

  @override
  State<SearchCardUserScreen> createState() => _SearchCardUserScreen();
}

class _SearchCardUserScreen extends State<SearchCardUserScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthController>().appUser;
    return ChangeNotifierProvider<SearchController>(
        create: (_) => SearchController(user!.uid!),
        builder: (context, child) {
          final controller = context.watch<SearchController>();
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderSearch(),
                  Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 2),
                      child: Text("List User:", style: txtMedium(16))
                  ),
                  Expanded(
                    child: controller.listSearchUser.isNotEmpty ?
                    ListView.builder(
                      itemCount: controller.listSearchUser.length,
                      itemBuilder: (context, index) => SearchCardUserItem(
                        appUser: controller.listSearchUser[index],
                        user: widget.user,
                        receiver: widget.receiver,
                        chatRoomId: widget.chatRoomId,
                      ),
                    ) :
                    ListView.builder(
                      itemCount: controller.listAllUser.length,
                      itemBuilder: (context, index) => SearchCardUserItem(
                        appUser: controller.listAllUser[index],
                        user: widget.user,
                        receiver: widget.receiver,
                        chatRoomId: widget.chatRoomId,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
