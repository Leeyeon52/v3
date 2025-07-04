import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/base_screen.dart'; // BaseScreen 임포트
import '../../../core/result.dart'; // Result 클래스 임포트
import '../viewmodel/auth_viewmodel.dart'; // AuthViewModel 임포트
import '../model/user.dart'; // User 모델 임포트

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseScreen<LoginScreen> { // BaseScreen 상속
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final authViewModel = context.read<AuthViewModel>();
    showLoading(true); // 로딩 시작

    final email = _emailController.text;
    final password = _passwordController.text;

    final result = await authViewModel.login(email, password);

    showLoading(false); // 로딩 종료

    if (result is Success<User>) { // Result<User> 타입 확인
      if (context.mounted) {
        context.go('/home'); // 로그인 성공 시 홈 화면으로 이동
        showSnackBar('로그인 성공!'); // BaseScreen의 showSnackBar 사용
      }
    } else if (result is Failure<User>) { // Result<User> 타입 확인
      if (context.mounted) {
        showSnackBar('로그인 실패: ${result.message}'); // BaseScreen의 showSnackBar 사용
      }
    }
  }

  @override
  Widget buildBody(BuildContext context) { // buildBody 구현
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // 버튼 너비를 최대로
              ),
              child: const Text('로그인'),
            ),
            TextButton(
              onPressed: () => context.go('/register'),
              child: const Text('회원가입'),
            ),
            TextButton(
              onPressed: () => context.go('/find-account'),
              child: const Text('아이디/비밀번호 찾기'),
            ),
          ],
        ),
      ),
    );
  }
}
