import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    this.id,
    this.username,
    this.receiver,
    this.sentAt,
    this.message,
  });

  String id;
  String username;
  String receiver;
  String sentAt;
  String message;

  // factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
  // id: json["id"],
  // username: json["username"],
  // receiver:json['receiver'],
  // sentAt: json["sentAt"],
  // message: json["message"],
  // );

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        id: json["id"],
        username: json["username"],
        receiver: json['receiver'],
        sentAt: json["sentAt"],
        message: json["message"]);
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        'receiver': receiver,
        "sentAt": sentAt,
        "message": message,
      };
}
