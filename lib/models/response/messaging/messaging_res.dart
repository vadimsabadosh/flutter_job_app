import 'dart:convert';

List<ReceivedMessage> receivedMessageFromJson(String str) =>
    List<ReceivedMessage>.from(
        json.decode(str).map((x) => ReceivedMessage.fromJson(x)));

class ReceivedMessage {
  final String id;
  final String content;
  final Sender sender;
  final String receiver;
  final Chat chat;
  final List<dynamic> readBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReceivedMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.receiver,
    required this.chat,
    required this.readBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReceivedMessage.fromJson(Map<String, dynamic> json) =>
      ReceivedMessage(
        id: json["_id"],
        content: json["content"],
        sender: Sender.fromJson(json["sender"]),
        receiver: json["receiver"],
        chat: Chat.fromJson(json["chat"]),
        readBy: List<dynamic>.from(json["readBy"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}

class Chat {
  final String id;
  final String chatName;
  final bool isGroup;
  final List<Sender> users;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String latestMessage;

  Chat({
    required this.id,
    required this.chatName,
    required this.isGroup,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
    required this.latestMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["_id"],
        chatName: json["chatName"],
        isGroup: json["isGroup"],
        users: List<Sender>.from(json["users"].map((x) => Sender.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        latestMessage: json["latestMessage"],
      );
}

class Sender {
  final String id;
  final String username;
  final String email;
  final String profile;

  Sender({
    required this.id,
    required this.username,
    required this.email,
    required this.profile,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        profile: json["profile"],
      );
}
