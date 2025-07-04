import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell; // ✅ StatefulNavigationShell 타입으로 변경

  const MainScaffold({
    super.key,
    required this.navigationShell, // ✅ required로 변경
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell, // ✅ navigationShell 자체를 body로 전달
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '챗봇',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: '진단',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
        currentIndex: navigationShell.currentIndex, // ✅ 현재 인덱스 사용
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed, // 아이템이 4개 이상일 때 필요
      ),
    );
  }

  void _onTap(int index) {
    // 탭을 눌렀을 때 해당 브랜치로 이동
    navigationShell.goBranch(
      index,
      // 다른 탭으로 이동할 때 기존 스택을 유지할지 여부
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}