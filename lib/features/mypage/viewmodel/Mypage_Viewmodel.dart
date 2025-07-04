import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/diagnosis_record.dart'; // DiagnosisRecord, RemoteDiagnosisRecord 모델 임포트 확인

class MyPageViewModel extends ChangeNotifier { // 클래스 이름 MyPageViewModel로 수정
  String? _userName;
  String? _userPhone;
  String? _userEmail;
  List<DiagnosisRecord> _diagnosisRecords = [];
  List<RemoteDiagnosisRecord> _remoteDiagnosisRecords = [];

  String? get userName => _userName;
  String? get userPhone => _userPhone;
  String? get userEmail => _userEmail;
  List<DiagnosisRecord> get diagnosisRecords => List.unmodifiable(_diagnosisRecords);
  List<RemoteDiagnosisRecord> get remoteDiagnosisRecords => List.unmodifiable(_remoteDiagnosisRecords);

  MyPageViewModel() { // 생성자 이름 MyPageViewModel로 수정
    _loadUserInfo();
    _loadDummyDiagnosisRecords(); // 더미 데이터 로드
    _loadDummyRemoteDiagnosisRecords(); // 더미 데이터 로드
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('userEmail');
    _userName = prefs.getString('userName');
    _userPhone = prefs.getString('userPhone');
    notifyListeners();
  }

  // 외부에서 호출될 수 있는 Public 메서드 (이름 통일)
  Future<void> loadUserInfo() async {
    await _loadUserInfo(); // 내부 _loadUserInfo 호출
  }

  Future<void> updateUserInfo({String? name, String? phone}) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) {
      _userName = name;
      await prefs.setString('userName', name);
    }
    if (phone != null) {
      _userPhone = phone;
      await prefs.setString('userPhone', phone);
    }
    notifyListeners();
  }

  void _loadDummyDiagnosisRecords() {
    _diagnosisRecords = [
      DiagnosisRecord(
        id: 'd1',
        date: DateTime(2024, 7, 1),
        type: '충치',
        result: '초기 충치 발견',
        imageUrl: 'assets/images/sample_tooth_1.png',
        detail: '어금니에 작은 충치가 발견되었습니다. 정기적인 검진이 필요합니다.',
      ),
      DiagnosisRecord(
        id: 'd2',
        date: DateTime(2024, 6, 25),
        type: '치주염',
        result: '잇몸 염증 소견',
        imageUrl: 'assets/images/sample_tooth_2.png',
        detail: '잇몸에 경미한 염증이 있습니다. 양치질 습관 개선이 필요합니다.',
      ),
    ];
    notifyListeners();
  }

  void _loadDummyRemoteDiagnosisRecords() {
    _remoteDiagnosisRecords = [
      RemoteDiagnosisRecord(
        id: 'rd1',
        date: DateTime(2024, 7, 2),
        type: '구강 검진 요청',
        status: '진행 중',
        doctorComment: '아직 검토 중입니다.',
        imageUrl: 'assets/images/sample_mouth_1.png',
      ),
      RemoteDiagnosisRecord(
        id: 'rd2',
        date: DateTime(2024, 6, 28),
        type: '통증 상담',
        status: '완료',
        doctorComment: '신경치료가 필요할 수 있습니다. 내원하세요.',
        imageUrl: 'assets/images/sample_mouth_2.png',
      ),
    ];
    notifyListeners();
  }
}