class ChatMessage {
  final String text;
  final bool isUser; // true면 사용자 메시지, false면 챗봇 메시지

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}