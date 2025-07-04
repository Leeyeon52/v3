import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/base_screen.dart'; // BaseScreen 임포트
import '../../../core/result.dart'; // Result 클래스 임포트
import '../viewmodel/auth_viewmodel.dart'; // AuthViewModel 임포트

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends BaseScreen<RegisterScreen> { // BaseScreen 상속
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final authViewModel = context.read<AuthViewModel>();
    showLoading(true); // 로딩 시작

    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;

    final result = await authViewModel.register(email, password, name);

    showLoading(false); // 로딩 종료

    if (result is Success<bool> && result.data == true) { // Result<bool> 타입 확인
      if (context.mounted) {
        showSnackBar('회원가입 성공!'); // BaseScreen의 showSnackBar 사용
        context.go('/login'); // 회원가입 성공 시 로그인 화면으로 이동
      }
    } else if (result is Failure<bool>) { // Result<bool> 타입 확인
      if (context.mounted) {
        showSnackBar('회원가입 실패: ${result.message}'); // BaseScreen의 showSnackBar 사용
      }
    }
  }

  @override
  Widget buildBody(BuildContext context) { // buildBody 구현
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
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
            const SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('회원가입'),
            ),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('로그인 화면으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
