import 'package:appchat/views/receiver_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../controllers/message_controller.dart';
import '../../../models/app_user.dart';
import '../../../views/videocall_screen.dart';
import '../../constants.dart';
import '../../utils/utils.dart';

class HeaderConversation extends StatelessWidget {
  const HeaderConversation({
    Key? key,
    required this.receiver,
    required this.chatRoomId,
    required this.userName
  }) : super(key: key);

  final String? chatRoomId;
  final String userName;
  final AppUser receiver;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                      backIcon,
                      width: 30,
                      height: 30,
                      color: primaryColor
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.withOpacity(0.6),
                  backgroundImage: receiver.photoUrl != null ?
                  NetworkImage(receiver.photoUrl!) : null,
                  child: receiver.photoUrl != null ? null :
                  Text(
                      Utils.nameInit(receiver.displayName ?? ""),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue
                      )
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReceiverProfileScreen(receiver: receiver,)
                          )
                      );
                    },
                    child: Text(
                      receiver.displayName ?? "",
                      style: txtSemiBold(18),
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // VideoCallItem(chatRoomId: chatRoomId!,)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
                onTap: () {
                  context.read<MessageController>().onSend(mess: "Join Call !");
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return VideoConferencePage(conferenceID: '$chatRoomId', userName: userName, turnOnCam: false,);
                  }));
                },
                child: const Icon(Icons.call, color: primaryColor, size: 25,)
            ),
          ),
          InkWell(
            onTap: () {
              context.read<MessageController>().onSend(mess: "Join VideoCall !");
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return VideoConferencePage(conferenceID: '$chatRoomId', userName: userName, turnOnCam: true,);
              }));
            },
            child: const Icon(Icons.videocam, color: primaryColor, size: 35,)
          )
        ],
      ),
    );
  }
}
