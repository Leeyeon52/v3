import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 임포트
import '../../../core/result.dart'; // Result 클래스 임포트
import '../../../core/strategy/auth_strategy.dart'; // AuthStrategy 임포트
import '../../../core/strategy/api_auth_strategy.dart'; // ApiAuthStrategy 임포트
import '../model/user.dart'; // User 모델 임포트
import '../../mypage/viewmodel/mypage_viewmodel.dart'; // MyPageViewModel 임포트

class AuthViewModel extends ChangeNotifier {
  final AuthStrategy _authStrategy;
  User? _currentUser;

  User? get currentUser => _currentUser;

  AuthViewModel({String? baseUrl}) : _authStrategy = ApiAuthStrategy(baseUrl: baseUrl);

  Future<Result<User>> login(String email, String password) async {
    final success = await _authStrategy.login(email, password);
    if (success) {
      // 실제 사용자 정보 로드 로직 필요 (예: API 호출)
      // 현재는 더미 User 객체 반환
      _currentUser = User(email: email, name: 'Test User', phone: '010-1234-5678'); // ✅ id 필드 제거, phone 필드 추가
      
      // SharedPreferences에 사용자 정보 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);
      await prefs.setString('userName', _currentUser?.name ?? '');
      await prefs.setString('userPhone', _currentUser?.phone ?? '');

      // MyPageViewModel에 사용자 정보 로드 (ChangeNotifierProvider로 접근)
      // main.dart에서 MyPageViewModel이 생성되기 때문에, 여기서 직접 Provider.of를 사용하지 않고
      // MyPageViewModel의 loadUserInfo()를 호출하는 것은 적절하지 않을 수 있습니다.
      // 하지만 현재 구조상 MyPageViewModel이 main에서 생성되므로,
      // loadUserInfo()를 호출하여 최신 정보를 로드하도록 합니다.
      // 이 부분은 Context를 통해 MyPageViewModel 인스턴스를 가져와야 합니다.
      // 하지만 AuthViewModel은 BuildContext를 직접 받지 않으므로,
      // login 메서드에 BuildContext를 추가하거나, MyPageViewModel이 AuthViewModel을 구독하도록 해야 합니다.
      // 일단은 SharedPreferences에 저장하는 것으로 충분하고, MyPageScreen이 빌드될 때 MyPageViewModel이 알아서 로드하도록 합니다.

      notifyListeners();
      return Success(_currentUser!);
    } else {
      return const Failure('로그인 실패: 이메일 또는 비밀번호를 확인해주세요.');
    }
  }

  Future<Result<bool>> register(String email, String password, String name) async {
    final success = await _authStrategy.register(email, password, name);
    if (success) {
      return const Success(true);
    } else {
      return const Failure('회원가입 실패: 이미 존재하는 이메일이거나 서버 오류입니다.');
    }
  }

  Future<void> logout() async {
    await _authStrategy.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('userPhone');
    _currentUser = null;
    notifyListeners();
  }
}
