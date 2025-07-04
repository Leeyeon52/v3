import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_strategy.dart'; // AuthStrategy 임포트

class ApiAuthStrategy implements AuthStrategy {
  final String _baseUrl; // ✅ final로 선언하여 불변성 유지

  ApiAuthStrategy({String? baseUrl})
      : _baseUrl = baseUrl ?? "http://10.0.2.2:5000"; // 기본값 설정

  @override
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final token = data['token']; // 서버 응답에서 토큰 추출
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token); // 토큰 저장
          return true;
        }
        return false;
      } else {
        print('로그인 실패: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('로그인 중 오류 발생: $e');
      return false;
    }
  }

  @override
  Future<bool> register(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password, 'name': name}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('회원가입 실패: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('회원가입 중 오류 발생: $e');
      return false;
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken'); // 토큰 삭제
    // 필요시 서버 로그아웃 API 호출
  }
}
