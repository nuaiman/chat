import 'dart:convert';

class ChatModel {
  final String id;
  final String senderId;
  final String otherId;
  final String message;

  ChatModel({
    required this.id,
    required this.senderId,
    required this.otherId,
    required this.message,
  });

  ChatModel copyWith({
    String? id,
    String? senderId,
    String? otherId,
    String? message,
  }) {
    return ChatModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      otherId: otherId ?? this.otherId,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'senderId': senderId});
    result.addAll({'otherId': otherId});
    result.addAll({'message': message});

    return result;
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      otherId: map['otherId'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatModel(id: $id, senderId: $senderId, otherId: $otherId, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.id == id &&
        other.senderId == senderId &&
        other.otherId == otherId &&
        other.message == message;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderId.hashCode ^
        otherId.hashCode ^
        message.hashCode;
  }
}
