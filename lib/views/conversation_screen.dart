import 'package:appchat/views/search_card_user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../controllers/firebase_auth_controller.dart';
import '../controllers/message_controller.dart';
import '../controllers/search_controller.dart';
import '../data_sources/firebase_services.dart';
import '../models/app_user.dart';
import '../models/message.dart';
import '../resources/constants.dart';
import '../resources/widgets/conversation/header_conversation.dart';
import '../resources/widgets/conversation/input_message.dart';
import '../resources/widgets/conversation/message_item.dart';
import '../resources/widgets/conversation/option_item.dart';
import '../resources/widgets/conversation/sticker_item.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key, required this.receiver, this.chatRoomId})
      : super(key: key);
  final AppUser receiver;
  final String? chatRoomId;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  FirebaseServices firebaseServices = FirebaseServices();
  final TextEditingController _messController = TextEditingController();
  bool isShowOption = false;
  bool isShowSticker = false;

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthController>().appUser!;
    final SearchController search = SearchController(user.uid!);

    return ChangeNotifierProvider<MessageController>(
      create: (_) => MessageController(
          user: user, receiver: widget.receiver, chatRoomId: widget.chatRoomId),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: context.watch<MessageController>().isLoading ?
            const Center(
              child: CircularProgressIndicator(),
            ) :
            SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      HeaderConversation(receiver: widget.receiver, chatRoomId: widget.chatRoomId, userName: user.displayName!,),
                      context.watch<MessageController>().chatRoomId != null ?
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: firebaseServices.getStreamMessage(context.watch<MessageController>().chatRoomId!),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            List<Message> listMessage = snapshot.data!.docs.map<Message>((e) => Message.fromJson(e.data())).toList();
                            return Expanded(
                                child: ListView.builder(
                                  cacheExtent: 1000,
                                  padding: const EdgeInsets.only(bottom: 24),
                                  itemCount: listMessage.length,
                                  reverse: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final isMe = user.uid == listMessage[index].senderId;
                                    bool isMidle = false;
                                    bool isLast = false;
                                    if (index != 0 && index < listMessage.length - 1) {
                                      isMidle = listMessage[index].senderId == listMessage[index - 1].senderId &&
                                      listMessage[index].senderId == listMessage[index + 1].senderId;
                                      isLast = listMessage[index].senderId == listMessage[index - 1].senderId &&
                                      listMessage[index].senderId != listMessage[index + 1].senderId;
                                    }
                                    AppUser appUser = user;
                                    for (var element in search.listAllUser) {
                                      if (listMessage[index].message.toString() == element.uid.toString()) {
                                        appUser = element;
                                        break;
                                      }
                                    }
                                    return MessageItem(
                                      message: listMessage[index],
                                      isMe: isMe,
                                      isMidle: isMidle,
                                      isLast: isLast,
                                      appUser: appUser,
                                    );
                                  },
                                )
                            );
                          }
                      ) :
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 56),
                            child: Text(
                              "Say Hello to your new friend",
                              style: txtMedium(24),
                            ),
                          ),
                        )
                      ),
                      isShowSticker ?
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white
                          ),
                          padding: const EdgeInsets.all(5),
                          height: 180,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const <Widget>[
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fwetransfer0.gif?alt=media&token=6a86d5e3-3de8-48b2-a6dd-35f2cf8f78e5',
                                        path: 'assets/sticker/wetransfer0.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fwetransfer1.gif?alt=media&token=1167bab8-c846-4740-b4ee-8212ff0a6152',
                                        path: 'assets/sticker/wetransfer1.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fwetransfer2.gif?alt=media&token=3b20c088-7a16-43b9-a0fe-e96a32f84ba1',
                                        path: 'assets/sticker/wetransfer2.gif'
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const <Widget>[
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fwetransfer3.gif?alt=media&token=368b9131-5084-4a63-9ba8-12c211587376',
                                        path: 'assets/sticker/wetransfer3.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fwetransfer4.gif?alt=media&token=2628a56a-9c1a-41ab-b8ab-7750ee3fd831',
                                        path: 'assets/sticker/wetransfer4.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fwetransfer5.gif?alt=media&token=5fa09a4d-1142-4514-982d-3c77bc38695c',
                                        path: 'assets/sticker/wetransfer5.gif'
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const <Widget>[
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fwetransfer6.gif?alt=media&token=bd9c5f01-d4ae-47e6-a9bd-0e73a545f890',
                                        path: 'assets/sticker/wetransfer6.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fwetransfer7.gif?alt=media&token=bac02bda-36a6-4a4c-a490-5536c42c2cb7',
                                        path: 'assets/sticker/wetransfer7.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fwetransfer8.gif?alt=media&token=952dce2d-8827-46a8-98ba-47390b3414d7',
                                        path: 'assets/sticker/wetransfer8.gif'
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const <Widget>[
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fwetransfer9.gif?alt=media&token=fee25b5a-6e83-4205-9e8a-f9a357731966',
                                        path: 'assets/sticker/wetransfer9.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fwetransfer10.gif?alt=media&token=dccbf17d-70f0-4f52-98ad-4687b5604b8c',
                                        path: 'assets/sticker/wetransfer10.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fmimi2.gif?alt=media&token=ba5cd650-59c5-4032-ac21-a575b048d99b',
                                        path: 'assets/sticker/mimi2.gif'
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const <Widget>[
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fmimi3.gif?alt=media&token=9788ab57-455c-49d1-8258-5c9a2020c1c1',
                                        path: 'assets/sticker/mimi3.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fmimi4.gif?alt=media&token=1cbf356e-1d84-4f65-b49d-5772ec78fc64',
                                        path: 'assets/sticker/mimi4.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fmimi5.gif?alt=media&token=84c1febf-b883-4109-8236-7be19f62046f',
                                        path: 'assets/sticker/mimi5.gif'
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const <Widget>[
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fmimi6.gif?alt=media&token=76724013-de78-49c8-9eff-654413eeabb7',
                                        path: 'assets/sticker/mimi6.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fmimi7.gif?alt=media&token=56fa6769-4ece-4f55-b178-ef14299600ef',
                                        path: 'assets/sticker/mimi7.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fmimi8.gif?alt=media&token=0f36bba2-cce5-46fb-a731-0ab63185dc53',
                                        path: 'assets/sticker/mimi8.gif'
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const <Widget>[
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2Fmimi9.gif?alt=media&token=814d6ef5-f109-4e09-90df-abfac47950ce',
                                        path: 'assets/sticker/mimi9.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F16.gif?alt=media&token=0ad3c288-7607-4ed0-ae54-193cd851c776',
                                        path: 'assets/sticker/16.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F17.gif?alt=media&token=109e350b-f089-4d4d-9995-ab4e7fffed83',
                                        path: 'assets/sticker/17.gif'
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F1.gif?alt=media&token=d36da610-275f-42f2-bfb9-4f3c112fdc01',
                                        path: 'assets/sticker/1.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F2.gif?alt=media&token=814182e6-4aa5-4db9-a7ff-e37f47faa386',
                                        path: 'assets/sticker/2.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F3.gif?alt=media&token=7d713a5e-407b-4d97-ad7e-041da2fdc3cb',
                                        path: 'assets/sticker/3.gif'
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const <Widget>[
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F4.gif?alt=media&token=b521a16b-1ed1-40d9-9e98-c69e9510e845',
                                        path: 'assets/sticker/4.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F5.gif?alt=media&token=45477c93-d5db-46a6-ae46-d367b47b37d2',
                                        path: 'assets/sticker/5.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F6.gif?alt=media&token=17f66d32-a5e4-419f-aebe-519a9807ce69',
                                        path: 'assets/sticker/6.gif'
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const <Widget>[
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F7.gif?alt=media&token=8027822c-4911-4860-81d6-ec53c60c2b41',
                                        path: 'assets/sticker/7.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F8.gif?alt=media&token=fe3e7df3-8073-4bcd-acdc-5c73f447a0fd',
                                        path: 'assets/sticker/8.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F9.gif?alt=media&token=76a3d7ee-c7ed-4155-b9fa-b684b52c85aa',
                                        path: 'assets/sticker/9.gif'
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const <Widget>[
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F10.gif?alt=media&token=8e43c273-7cd2-4197-973e-9678e6e726c5',
                                        path: 'assets/sticker/10.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F11.gif?alt=media&token=da1aed18-2bc4-4a09-af87-189112262b11',
                                        path: 'assets/sticker/11.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F12.gif?alt=media&token=89e7275b-3387-44f9-83b5-d61d6ae354b3',
                                        path: 'assets/sticker/12.gif'
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const <Widget>[
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F13.gif?alt=media&token=6808a488-d931-4580-a924-5a8714da007b',
                                        path: 'assets/sticker/13.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F14.gif?alt=media&token=6e9db9f7-4245-4f3f-9905-1a369e910756',
                                        path: 'assets/sticker/14.gif'
                                    ),
                                    StickerItem(
                                        url: 'https://firebasestorage.googleapis.com/v0/b/chat-5a0d2.appspot.com/o/sticker%2F15.gif?alt=media&token=c1827cdd-d924-43ce-8dae-2883ead6fa76',
                                        path: 'assets/sticker/15.gif'
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ) :
                      Container(),
                      InputMessage(
                        controller: _messController,
                        iconOption: isShowOption ? closeIcon : addIcon,
                        onTapOption: () {
                          setState(() {
                            isShowOption = !isShowOption;
                          });
                        },
                        onTapTf: () {
                            setState(() {
                              if (isShowSticker) {
                                isShowSticker = !isShowSticker;
                              }
                            });
                        },
                      ),
                    ],
                  ),
                  OptionItemMessage(
                    onTap: () async {
                       context
                          .read<MessageController>()
                           .onPickCamera();
                    },
                    duration: const Duration(milliseconds: 1000),
                    color: const Color(0xff0066ff),
                    icon: cameraIcon,
                    isShow: isShowOption,
                    showPositionBottom: 72,
                    showPositionLeft: 16,
                  ),
                  OptionItemMessage(
                    onTap: () async {
                      await context
                          .read<MessageController>()
                          .mediaPicker(context, RequestType.image);
                    },
                    duration: const Duration(milliseconds: 900),
                    color: const Color(0xff4F2BFF),
                    icon: imageIcon,
                    isShow: isShowOption,
                    showPositionBottom: 72,
                    showPositionLeft: 16 * 2 + 38,
                  ),
                  OptionItemMessage(
                    onTap: () async {
                      await context
                          .read<MessageController>()
                          .mediaPicker(context, RequestType.video);
                    },
                    duration: const Duration(milliseconds: 800),
                    color: const Color(0xff38963C),
                    icon: videoIcon,
                    isShow: isShowOption,
                    showPositionBottom: 72,
                    showPositionLeft: 16 * 3 + 38 * 2,
                  ),
                  OptionItemMessage(
                    onTap: () {
                        setState(() {
                          isShowSticker = !isShowSticker;
                          isShowOption = !isShowOption;
                        });
                    },
                    duration: const Duration(milliseconds: 800),
                    color: const Color(0xffff00e9),
                    icon: sticker,
                    isShow: isShowOption,
                    showPositionBottom: 72,
                    showPositionLeft: 16 * 4 + 38 * 3,
                  ),
                  OptionItemMessage(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SearchCardUserScreen(
                                user: user,
                                receiver: widget.receiver,
                                chatRoomId: widget.chatRoomId,
                              )
                          )
                      );
                    },
                    duration: const Duration(milliseconds: 800),
                    color: const Color(0xff008cff),
                    icon: cardUser,
                    isShow: isShowOption,
                    showPositionBottom: 72,
                    showPositionLeft: 16 * 5 + 38 * 4,
                  ),
                  OptionItemMessage(
                    onTap: () async {
                      LocationPermission permission;
                      permission = await Geolocator.requestPermission();
                      var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                      String locationMessage = "${position.latitude}+${position.longitude}";
                      setState(() {
                        context
                            .read<MessageController>()
                            .onSend(mess: locationMessage, type: "location");
                      });
                    },
                    duration: const Duration(milliseconds: 800),
                    color: const Color(0xFF000000),
                    icon: location,
                    isShow: isShowOption,
                    showPositionBottom: 72,
                    showPositionLeft: 16 * 6 + 38 * 5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
