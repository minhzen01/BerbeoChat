import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String? roomChatId;
  String? message;
  String? senderId;
  String? senderName;
  Timestamp? timeStamp;
  List<String>? medias;
  String? type;

  Message(
      {this.id,
      this.roomChatId,
      this.message,
      this.senderId,
      this.senderName,
      this.timeStamp,
      this.medias,
      this.type});

  Message.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    roomChatId = json["room_chat_id"];
    medias = json["medias"] == null ? null : List<String>.from(json["medias"]);
    message = json["message"];
    senderId = json["sender_id"];
    senderName = json["sender_name"];
    timeStamp = json["time_stamp"];
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["room_chat_id"] = roomChatId;
    data["message"] = message;
    data["sender_id"] = senderId;
    data["sender_name"] = senderName;
    data["medias"] = medias;
    data["time_stamp"] = FieldValue.serverTimestamp();
    data["type"] = type;
    return data;
  }
}
