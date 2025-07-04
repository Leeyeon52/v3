import 'package:flutter/foundation.dart';

enum MessageSender { user, bot } // ✅ MessageSender enum 추가

class ChatMessage {
  final String text;
  final MessageSender sender; // ✅ sender 필드 사용
  final DateTime timestamp; // ✅ timestamp 필드 추가

  ChatMessage({
    required this.text,
    required this.sender, // ✅ sender 필드 필수
    required this.timestamp, // ✅ timestamp 필드 필수
  });

  // JSON 직렬화 (SharedPreferences 저장을 위해 필요)
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sender': sender.toString().split('.').last, // 'user' 또는 'bot' 문자열로 저장
      'timestamp': timestamp.toIso8601String(), // ISO 8601 문자열로 저장
    };
  }

  // JSON 역직렬화 (SharedPreferences 로드를 위해 필요)
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] as String,
      sender: (json['sender'] as String) == 'user' ? MessageSender.user : MessageSender.bot,
      timestamp: DateTime.parse(json['timestamp'] as String), // 문자열을 DateTime으로 파싱
    );
  }
}
