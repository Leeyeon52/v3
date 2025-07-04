import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/mypage_viewmodel.dart'; // ✅ MyPageViewModel 사용

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final mypageViewModel = context.watch<MyPageViewModel>(); // ✅ MyPageViewModel 사용

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('이메일: ${mypageViewModel.userEmail ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
              Text('이름: ${mypageViewModel.userName ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
              Text('전화번호: ${mypageViewModel.userPhone ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/mypage/edit_profile'),
                child: const Text('프로필 수정'),
              ),
              ElevatedButton(
                onPressed: () => context.go('/mypage/change_password'),
                child: const Text('비밀번호 변경'),
              ),
              ElevatedButton(
                onPressed: () => context.go('/mypage/chat_history'),
                child: const Text('챗봇 상담 기록'),
              ),
              ElevatedButton(
                onPressed: () => context.go('/mypage/diagnosis_history'),
                child: const Text('자가 진단 기록'),
              ),
              ElevatedButton(
                onPressed: () => context.go('/mypage/remote_diagnosis_history'),
                child: const Text('원격 진단 기록'),
              ),
              ElevatedButton(
                onPressed: () => context.go('/mypage/reservation_history'),
                child: const Text('예약 기록'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}