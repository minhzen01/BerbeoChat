import 'package:cloud_firestore/cloud_firestore.dart';

class RoomChat {
  String? id;
  List<String>? membersId;
  String? message;
  String? senderId;
  Timestamp? timeStamp;

  RoomChat(
      {this.id, this.membersId, this.message, this.senderId, this.timeStamp});

  RoomChat.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    membersId = json["members_id"] == null
        ? null
        : List<String>.from(json["members_id"]);
    message = json["message"];
    senderId = json["sender_id"];
    timeStamp = json["time_stamp"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    if (membersId != null) data["members_id"] = membersId;
    data["message"] = message;
    data["sender_id"] = senderId;
    data["time_stamp"] = FieldValue.serverTimestamp();
    return data;
  }
}
