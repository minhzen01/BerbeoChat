import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../data_sources/firebase_services.dart';
import '../../../models/app_user.dart';
import '../../../models/room_chat.dart';
import '../../../views/search_screen.dart';
import '../../constants.dart';
import 'item_room_chat.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({
    Key? key,
    required FirebaseServices firebaseServices,
    required this.user,
  })  : firebaseServices = firebaseServices, super(key: key);

  final FirebaseServices firebaseServices;
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firebaseServices.getStreamRoomChat(user.uid!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isNotEmpty) {
            List<RoomChat> listRoomChat = [];
            for (var doc in snapshot.data!.docs) {
              final roomChat = RoomChat.fromJson(doc.data());
              listRoomChat.add(roomChat);
            }
            listRoomChat.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));

            return ListView.builder(
              padding: const EdgeInsets.only(top: 15),
              itemCount: listRoomChat.length,
              itemBuilder: (context, index) => ItemRoomChat(
                userId: user.uid!,
                firebaseService: firebaseServices,
                roomChat: listRoomChat[index],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 56),
                    child: Text(
                      "You haven't messaged anyone yet",
                      textAlign: TextAlign.center,
                      style: txtMedium(24),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SearchScreen()
                            )
                        );
                      },
                      icon: SvgPicture.asset(
                          searchIcon,
                          width: 24,
                          height: 24,
                          color: primaryColor
                      ),
                      label: Text(
                        "Find new friends",
                        style: txtMedium(24, primaryColor),
                      )
                  )
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
