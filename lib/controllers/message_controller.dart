import 'dart:io';
import 'dart:typed_data';
import 'package:appchat/data_sources/firebase_services.dart';
import 'package:appchat/models/app_user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../models/room_chat.dart';
import '../resources/widgets/conversation/bottom_sheet_media.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class MessageController extends ChangeNotifier {
  final FirebaseServices firebaseServices = FirebaseServices();
  final AppUser user;
  final AppUser? receiver;
  String? chatRoomId;
  bool isLoading = true;
  List<Message> listMessage = [];
  List<File> files = [];
  List<AssetEntity> mediaList = [];
  List<Uint8List> mediaData = [];

  MessageController(
      {required this.user, required this.receiver, required this.chatRoomId}) {
    _init();
  }

  Future _init() async {
    if (chatRoomId == null && receiver != null) {
      chatRoomId =
          await firebaseServices.getIdRoomChat(user.uid!, receiver!.uid!);
    }
    isLoading = false;
    notifyListeners();
  }

  void onSendSticker({required List<String> url, String? type}) async {
    String ghep = user.uid! + receiver!.uid!;
    final roomId = chatRoomId ?? ghep;
    final messId = const Uuid().v4();
    await firebaseServices.sendMessage(
      roomChat: RoomChat(
        id: roomId,
        membersId: [user.uid!, receiver!.uid!],
        message:
        type == "image" ? "Image" : (type == "video" ? "Video" : "Audio"),
        senderId: user.uid,
      ),
      message: Message(
          id: messId,
          message: "",
          roomChatId: roomId,
          senderId: user.uid,
          senderName: user.displayName,
          medias: url,
          type: type),
    );
    await firebaseServices.updateMessageMedias(url, roomId, messId);
    if (chatRoomId == null && receiver != null) {
      chatRoomId =
      await firebaseServices.getIdRoomChat(user.uid!, receiver!.uid!);
    }
  }

  void onSend({required String mess, String? type}) async {
    String ghep = user.uid! + receiver!.uid!;
    final roomId = chatRoomId ?? ghep;
    await firebaseServices.sendMessage(
      roomChat: RoomChat(
        id: roomId,
        membersId: [user.uid!, receiver!.uid!],
        message: mess,
        senderId: user.uid,
      ),
      message: Message(
          id: const Uuid().v4(),
          message: mess,
          roomChatId: roomId,
          senderId: user.uid,
          senderName: user.displayName,
          type: type ?? "message"),
    );
    if (chatRoomId == null && receiver != null) {
      chatRoomId =
          await firebaseServices.getIdRoomChat(user.uid!, receiver!.uid!);
    }
    notifyListeners();
  }

  onSendMedia(List<int> indexs, String type) async {
    String ghep = user.uid! + receiver!.uid!;
    final roomId = chatRoomId ?? ghep;
    final messId = const Uuid().v4();
    List<String> medias = [];
    for (var i = 0; i < indexs.length; i++) {
      medias.add("");
    }
    await firebaseServices.sendMessage(
      roomChat: RoomChat(
        id: roomId,
        membersId: [user.uid!, receiver!.uid!],
        message:
        type == "image" ? "Image" : (type == "video" ? "Video" : "Audio"),
        senderId: user.uid,
      ),
      message: Message(
          id: messId,
          message: "",
          roomChatId: roomId,
          senderId: user.uid,
          senderName: user.displayName,
          medias: medias,
          type: type),
    );
    for (var i = 0; i < indexs.length; i++) {
      final file = await mediaList[indexs[i]].file;
      String? imageUrl =
          await firebaseServices.uploadFileMessage(user.uid!, file!);

      if (imageUrl != null) {
        medias[i] = imageUrl;
        await firebaseServices.updateMessageMedias(medias, roomId, messId);
      }
    }
    mediaList.clear();
    mediaData.clear();
    if (chatRoomId == null && receiver != null) {
      chatRoomId =
          await firebaseServices.getIdRoomChat(user.uid!, receiver!.uid!);
    }
  }

  Future onPickCamera() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      ImagePicker imagePicker = ImagePicker();
      final xFile = await imagePicker.pickImage(source: ImageSource.camera);
      if (xFile != null) {
        String ghep = user.uid! + receiver!.uid!;
        final roomId = chatRoomId ?? ghep;
        final messId = const Uuid().v4();
        await firebaseServices.sendMessage(
          roomChat: RoomChat(
            id: roomId,
            membersId: [user.uid!, receiver!.uid!],
            message: "Image",
            senderId: user.uid,
          ),
          message: Message(
              id: messId,
              message: "",
              roomChatId: roomId,
              senderId: user.uid,
              senderName: user.displayName,
              medias: [""],
              type: "image"),
        );
        final file = File(xFile.path);
        String? imageUrl =
            await firebaseServices.uploadFileMessage(user.uid!, file);
        if (imageUrl != null) {
          await firebaseServices
              .updateMessageMedias([imageUrl], roomId, messId);
        }
        if (chatRoomId == null && receiver != null) {
          chatRoomId =
              await firebaseServices.getIdRoomChat(user.uid!, receiver!.uid!);
        }
        notifyListeners();
      }
    }
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future mediaPicker(BuildContext context, RequestType requestType) async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList(
        type: requestType,
        hasAll: true,
        onlyAll: true,
      );
      mediaList = await list[0].getAssetListRange(start: 0, end: 100);

      for (var media in mediaList) {
        final data =
            await media.thumbnailDataWithSize(const ThumbnailSize(300, 300));
        mediaData.add(data!);
      }
      notifyListeners();
      await showModalBottomSheet<List<int>>(
        enableDrag: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) => BottomSheetMedia(mediaData: mediaData),
      ).then((value) {
        if (value != null) {
          if (requestType == RequestType.image) {
            onSendMedia(value, "image");
          } else {
            onSendMedia(value, "video");
          }
        } else {
          mediaList.clear();
          mediaData.clear();
        }
      });
    } else {
      PhotoManager.openSetting();
    }
  }
}
