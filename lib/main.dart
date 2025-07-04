import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/mypage/viewmodel/mypage_viewmodel.dart';
import 'features/chatbot/viewmodel/chat_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();

  final String globalBaseUrl = kIsWeb
      ? "http://127.0.0.1:5000"
      : "http://10.0.2.2:5000";

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel(baseUrl: globalBaseUrl)),
        ChangeNotifierProvider(create: (context) => MyPageViewModel()),
        ChangeNotifierProvider(create: (context) => ChatViewModel(baseUrl: globalBaseUrl)),
      ],
      child: const MediToothApp(),
    ),
  );
}

class MediToothApp extends StatelessWidget {
  const MediToothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MediTooth',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}