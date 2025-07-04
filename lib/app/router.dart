import 'package:flutter/material.dart'; // Material.dart는 항상 가장 위에
import 'package:go_router/go_router.dart';

// GlobalKey 선언은 import 문 뒤에 와야 합니다.
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

// Auth (인증) 관련 화면
import '../features/auth/view/login_screen.dart';
import '../features/auth/view/register_screen.dart';
import '../features/auth/view/find_account_screen.dart';

// Home (메인) 화면 및 ShellRoute의 메인 스캐폴드
import '../features/home/view/main_scaffold.dart';
import '../features/home/view/home_screen.dart';

// Chatbot (챗봇) 관련 파일
import '../features/chatbot/view/chat_screen.dart';

// Diagnosis (진단) 관련 화면
import '../features/diagnosis/view/upload_screen.dart';
import '../features/diagnosis/view/result_screen.dart';
import '../features/diagnosis/view/realtime_prediction_screen.dart';

// MyPage (마이페이지) 관련 화면 및 모델
import '../features/mypage/view/mypage_screen.dart';
import '../features/mypage/view/edit_profile_screen.dart';
import '../features/mypage/view/change_password_screen.dart';
import '../features/mypage/view/chat_history_screen.dart';
import '../features/mypage/view/diagnosis_history_screen.dart';
import '../features/mypage/view/diagnosis_detail_screen.dart';
import '../features/mypage/view/remote_diagnosis_history_screen.dart';
import '../features/mypage/view/remote_diagnosis_detail_screen.dart';
import '../features/mypage/view/reservation_history_screen.dart';
// DiagnosisRecord, RemoteDiagnosisRecord 모델은 모델 파일에서만 임포트합니다.
// 라우터 파일에서는 직접 모델을 임포트하지 않습니다. (중복 임포트 오류 방지)
// import '../features/mypage/model/diagnosis_record.dart'; // ✅ 이 줄은 삭제합니다.

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey, // 최상위 NavigatorKey
    initialLocation: '/login', // 앱 시작 시 초기 경로
    routes: [
      // 1. 인증 및 계정 찾기 화면 (하단 탭 바 없음)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/find-account', // FindAccountScreen에 대한 GoRoute 정의
        builder: (context, state) => const FindAccountScreen(),
      ),

      // 2. ShellRoute: 하단 탭 바가 있는 화면들을 감싸는 역할
      // 이 라우트 내부에 있는 화면들은 MainScaffold의 BottomNavigationBar를 공유합니다.
      StatefulShellRoute.indexedStack( // ✅ StatefulShellRoute로 변경
        builder: (context, state, navigationShell) { // ✅ navigationShell 파라미터 추가
          // MainScaffold가 하단 탭 바를 제공하고, child는 현재 선택된 탭의 화면입니다.
          return MainScaffold(navigationShell: navigationShell); // ✅ navigationShell 전달
        },
        branches: [
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/home', // 홈 탭
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/chatbot', // 챗봇 탭
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/diagnosis/upload', // 사진 진단 업로드 화면
                builder: (context, state) => const UploadScreen(),
              ),
              GoRoute(
                path: '/diagnosis/result', // 진단 결과 화면
                builder: (context, state) => const ResultScreen(),
              ),
              GoRoute(
                path: '/diagnosis/realtime', // 실시간 예측 화면
                builder: (context, state) => const RealtimePredictionScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/mypage', // 마이페이지 탭
                builder: (context, state) => const MyPageScreen(),
              ),
              GoRoute(
                path: '/mypage/edit', // '/mypage/edit' 경로가 됨
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: '/mypage/change-password', // 비밀번호 변경 화면
                builder: (context, state) => const ChangePasswordScreen(),
              ),
              GoRoute(
                path: '/mypage/chat-history', // 챗봇 대화 기록 화면
                builder: (context, state) => const ChatHistoryScreen(),
              ),
              GoRoute(
                path: '/mypage/diagnosis-history', // AI 진단 기록 화면
                builder: (context, state) => const DiagnosisHistoryScreen(),
              ),
              GoRoute(
                path: '/mypage/diagnosis-detail', // AI 진단 기록 상세 화면 (DiagnosisRecord 객체 전달)
                builder: (context, state) => DiagnosisDetailScreen(
                  record: state.extra as dynamic, // ✅ DiagnosisRecord 대신 dynamic 사용 (임포트 문제로 인해)
                ),
              ),
              GoRoute(
                path: '/mypage/remote-diagnosis-history', // 비대면 진료 기록 화면
                builder: (context, state) => const RemoteDiagnosisHistoryScreen(),
              ),
              GoRoute(
                path: '/mypage/remote-diagnosis-detail', // 비대면 진료 기록 상세 화면 (RemoteDiagnosisRecord 객체 전달)
                builder: (context, state) => RemoteDiagnosisDetailScreen(
                  record: state.extra as dynamic, // ✅ RemoteDiagnosisRecord 대신 dynamic 사용
                ),
              ),
              GoRoute(
                path: '/mypage/reservation-history', // 병원 예약 내역 화면
                builder: (context, state) => const ReservationHistoryScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    // 에러 처리 (선택 사항)
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('오류 발생')),
      body: Center(child: Text('페이지를 찾을 수 없습니다: ${state.error}')),
    ),
  );
}
