void main() async {
  // API URL을 설정하여 ApiAuthStrategy 객체 생성
  final authStrategy = ApiAuthStrategy(baseUrl: 'https://your-api-url.com/api');

  // 로그인 테스트
  final loginSuccess = await authStrategy.login('user123', 'password123');
  print('Login Success: $loginSuccess');

  // 회원가입 테스트
  final registerSuccess = await authStrategy.register('newUser', 'newPassword', 'John Doe');
  print('Register Success: $registerSuccess');

  // 로그아웃 테스트
  await authStrategy.logout();
}
