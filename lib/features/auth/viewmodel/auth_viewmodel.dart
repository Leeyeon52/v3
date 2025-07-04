import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/result.dart'; // Result 클래스 임포트
import '../model/user.dart'; // User 모델 임포트
import '../../../core/strategy/auth_strategy.dart'; // AuthStrategy 임포트
import '../../../core/strategy/api_auth_strategy.dart'; // ApiAuthStrategy 임포트

// ✅ MyPageViewModel 임포트 (로그인 성공 시 MyPageViewModel의 loadUser를 호출하기 위함)
import '../../mypage/viewmodel/mypage_viewmodel.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthStrategy _authStrategy;
  User? _currentUser; // 현재 로그인된 사용자 정보

  User? get currentUser => _currentUser;

  AuthViewModel({String? baseUrl}) : _authStrategy = ApiAuthStrategy(baseUrl: baseUrl);

  // 로그인 메서드
  Future<Result<User>> login(String email, String password, BuildContext context) async {
    final success = await _authStrategy.login(email, password);
    if (success) {
      // 로그인 성공 시 더미 유저 정보 설정 (실제 앱에서는 서버에서 유저 정보를 받아와야 함)
      _currentUser = User(email: email, name: "테스트유저", phone: "010-1234-5678");

      // SharedPreferences에 사용자 정보 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);
      await prefs.setString('userName', _currentUser?.name ?? '');
      await prefs.setString('userPhone', _currentUser?.phone ?? '');

      // MyPageViewModel에 사용자 정보 로드 (ChangeNotifierProvider로 접근)
      final mypageViewModel = Provider.of<MyPageViewModel>(context, listen: false);
      mypageViewModel.loadUserInfo(); // MyPageViewModel의 정보 로드 메서드 호출

      notifyListeners();
      return Success(_currentUser!);
    } else {
      _currentUser = null;
      notifyListeners();
      return const Failure('로그인 실패');
    }
  }

  // 회원가입 메서드
  Future<Result<bool>> register(String email, String password, String name) async {
    final success = await _authStrategy.register(email, password, name);
    if (success) {
      return const Success(true);
    } else {
      return const Failure('회원가입 실패');
    }
  }

  // 로그아웃 메서드
  Future<void> logout() async {
    await _authStrategy.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('userPhone');
    _currentUser = null;
    notifyListeners();
  }

  // 사용자 정보 로드 (앱 시작 시 등)
  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    final name = prefs.getString('userName');
    final phone = prefs.getString('userPhone');

    if (email != null) {
      _currentUser = User(email: email, name: name, phone: phone);
    } else {
      _currentUser = null;
    }
    notifyListeners();
  }
}