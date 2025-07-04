// lib/features/chatbot/viewmodel/chat_viewmodel.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../chatbot/model/chat_message.dart'; // ChatMessage 모델 임포트

class ChatViewModel extends ChangeNotifier { // ✅ ChatViewModel로 이름 변경
  final String baseUrl;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ChatViewModel({required this.baseUrl}); // ✅ 생성자에 baseUrl 파라미터 추가

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(text: text, isUser: true));
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: 실제 챗봇 API 엔드포인트로 변경해야 합니다.
      // final uri = Uri.parse('$baseUrl/api/chatbot'); // baseUrl 사용 예시
      // final response = await http.post(
      //   uri,
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({'message': text}),
      // );

      // if (response.statusCode == 200) {
      //   final responseBody = json.decode(utf8.decode(response.bodyBytes));
      //   _messages.add(ChatMessage(text: responseBody['response'], isUser: false));
      // } else {
      //   _errorMessage = '챗봇 서버 오류: ${response.statusCode}';
      //   _messages.add(ChatMessage(text: '오류가 발생했습니다. 다시 시도해주세요.', isUser: false));
      // }

      // 더미 응답 시뮬레이션
      await Future.delayed(const Duration(seconds: 1));
      _messages.add(ChatMessage(text: '안녕하세요! 무엇을 도와드릴까요?', isUser: false));
    } catch (e) {
      _errorMessage = '메시지 전송 중 오류 발생: $e';
      _messages.add(ChatMessage(text: '오류가 발생했습니다: $e', isUser: false));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
