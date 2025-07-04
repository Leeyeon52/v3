import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/base_screen.dart';
import '../viewmodel/mypage_viewmodel.dart'; // MyPageViewModel 임포트

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends BaseScreen<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final myPageViewModel = context.read<MyPageViewModel>(); // MyPageViewModel 사용
    _nameController.text = myPageViewModel.userName ?? '';
    _phoneController.text = myPageViewModel.userPhone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final myPageViewModel = context.read<MyPageViewModel>(); // MyPageViewModel 사용
    showLoading(true);

    await myPageViewModel.updateUserInfo(
      name: _nameController.text,
      phone: _phoneController.text,
    );

    showLoading(false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필이 성공적으로 저장되었습니다.')),
      );
      context.pop(); // 이전 화면으로 돌아가기
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    final myPageViewModel = context.watch<MyPageViewModel>(); // MyPageViewModel 사용
    // 상태 변화를 감지하여 텍스트 필드 업데이트 (불필요한 리빌드 방지)
    if (_nameController.text != (myPageViewModel.userName ?? '')) {
      _nameController.text = myPageViewModel.userName ?? '';
    }
    if (_phoneController.text != (myPageViewModel.userPhone ?? '')) {
      _phoneController.text = myPageViewModel.userPhone ?? '';
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: '전화번호'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}