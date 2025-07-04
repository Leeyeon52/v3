import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 임포트

import '../model/chat_message.dart'; // ChatMessage 모델 임포트

class ChatViewModel extends ChangeNotifier {
  final String? _baseUrl;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;

  ChatViewModel({String? baseUrl}) : _baseUrl = baseUrl {
    _loadChatHistory(); // ViewModel 초기화 시 대화 기록 로드
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 초기 메시지 추가 (예: 챗봇 환영 메시지)
  void addInitialMessage() {
    if (_messages.isEmpty || (_messages.length == 1 && _messages.first.isUser)) {
      // 메시지가 없거나, 첫 메시지가 사용자 메시지인 경우에만 초기 메시지 추가
      _messages.insert(0, ChatMessage(text: "안녕하세요! 무엇을 도와드릴까요?", isUser: false));
      notifyListeners();
    }
  }

  Future<void> sendUserMessage(String text) async {
    // 사용자 메시지 추가
    _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
    _setLoading(true); // 로딩 시작

    // 챗봇 응답을 기다리는 동안 로딩 메시지 표시
    _messages.add(ChatMessage(text: "답변을 생성 중입니다...", isUser: false, timestamp: DateTime.now()));
    notifyListeners();

    try {
      final url = Uri.parse('$_baseUrl/chat'); // 백엔드 챗봇 API 엔드포인트
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': text}),
      );

      // "답변을 생성 중입니다..." 메시지 제거
      if (_messages.isNotEmpty && _messages.last.text == "답변을 생성 중입니다...") {
        _messages.removeLast();
      }

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final botResponse = data['response'];
        _messages.add(ChatMessage(text: botResponse, isUser: false, timestamp: DateTime.now()));
      } else {
        _messages.add(ChatMessage(text: "오류 발생: ${response.statusCode}", isUser: false, timestamp: DateTime.now()));
        print('Failed to load bot response: ${response.statusCode}');
      }
    } catch (e) {
      // "답변을 생성 중입니다..." 메시지 제거 (오류 발생 시)
      if (_messages.isNotEmpty && _messages.last.text == "답변을 생성 중입니다...") {
        _messages.removeLast();
      }
      _messages.add(ChatMessage(text: "네트워크 오류: $e", isUser: false, timestamp: DateTime.now()));
      print('Error sending message: $e');
    } finally {
      _setLoading(false); // 로딩 종료
      _saveChatHistory(); // 대화 기록 저장
    }
  }

  // 대화 기록 로드 (SharedPreferences에서)
  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history = prefs.getStringList('chatHistory');
    if (history != null) {
      _messages.clear(); // 기존 메시지 초기화
      for (var item in history) {
        final Map<String, dynamic> msgMap = json.decode(item);
        _messages.add(ChatMessage(
          text: msgMap['text'],
          isUser: msgMap['isUser'],
          timestamp: DateTime.parse(msgMap['timestamp']), // 저장된 timestamp 파싱
        ));
      }
      addInitialMessage(); // 로드된 기록에 따라 초기 메시지 추가 여부 결정
      notifyListeners();
    } else {
      // 기록이 없을 때 초기 메시지 추가
      addInitialMessage();
    }
  }

  // 대화 기록 저장 (SharedPreferences에)
  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = _messages
        .map((msg) => json.encode({
              'text': msg.text,
              'isUser': msg.isUser,
              'timestamp': msg.timestamp.toIso8601String(), // timestamp 저장
            }))
        .toList();
    await prefs.setStringList('chatHistory', history);
  }

  // 대화 기록 초기화 (마이페이지에서 사용될 수 있음)
  Future<void> clearChatHistory() async {
    _messages.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chatHistory');
    addInitialMessage(); // 기록 삭제 후 초기 메시지 다시 표시
    notifyListeners();
  }

  // 마이페이지에서 대화 기록을 로드하기 위한 메서드 (현재 ViewModel의 메시지 목록을 반환)
  Future<List<ChatMessage>> loadChatHistory() async {
    // _messages는 이미 _loadChatHistory()에 의해 로드된 상태이므로 바로 반환
    return List.unmodifiable(_messages);
  }
}
