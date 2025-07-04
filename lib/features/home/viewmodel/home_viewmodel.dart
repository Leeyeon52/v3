// lib/features/home/viewmodel/home_viewmodel.dart
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  // 홈 화면에서 필요한 상태나 로직을 여기에 추가합니다.
  // 예: 공지사항, 추천 콘텐츠 등

  String _welcomeMessage = "메디투스에 오신 것을 환영합니다!";
  String get welcomeMessage => _welcomeMessage;

  void updateWelcomeMessage(String newMessage) {
    _welcomeMessage = newMessage;
    notifyListeners();
  }

  // 초기화 로직 (필요시)
  HomeViewModel() {
    _loadInitialData();
  }

  void _loadInitialData() {
    // 앱 시작 시 필요한 데이터 로드 (예: 사용자 이름 가져와서 환영 메시지 업데이트)
    // Future.delayed(Duration(seconds: 1), () {
    //   updateWelcomeMessage("홍길동님, 안녕하세요!");
    // });
  }
}
