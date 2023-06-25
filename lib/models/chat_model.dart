import 'dart:convert';

class ChatModel {
  final String identifier;
  final String senderId;
  final String otherId;
  final String message;
  final DateTime date;

  ChatModel({
    required this.identifier,
    required this.senderId,
    required this.otherId,
    required this.message,
    required this.date,
  });

  ChatModel copyWith({
    String? identifier,
    String? senderId,
    String? otherId,
    String? message,
    DateTime? date,
  }) {
    return ChatModel(
      identifier: identifier ?? this.identifier,
      senderId: senderId ?? this.senderId,
      otherId: otherId ?? this.otherId,
      message: message ?? this.message,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'identifier': identifier});
    result.addAll({'senderId': senderId});
    result.addAll({'otherId': otherId});
    result.addAll({'message': message});
    result.addAll({'date': date.millisecondsSinceEpoch});

    return result;
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      identifier: map['identifier'] ?? '',
      senderId: map['senderId'] ?? '',
      otherId: map['otherId'] ?? '',
      message: map['message'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatModel(identifier: $identifier, senderId: $senderId, otherId: $otherId, message: $message, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.identifier == identifier &&
        other.senderId == senderId &&
        other.otherId == otherId &&
        other.message == message &&
        other.date == date;
  }

  @override
  int get hashCode {
    return identifier.hashCode ^
        senderId.hashCode ^
        otherId.hashCode ^
        message.hashCode ^
        date.hashCode;
  }
}
