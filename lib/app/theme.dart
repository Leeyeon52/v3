import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF535D5C), // 주 색상
    hintColor: const Color(0xFF7A8685), // 강조 색상 (TextFormField label, hint)
    scaffoldBackgroundColor: Colors.white, // 배경 색상
    fontFamily: 'NotoSansKR', // 기본 폰트 설정

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF535D5C), // AppBar 배경 색상
      foregroundColor: Colors.white, // AppBar 아이콘 및 텍스트 색상
      elevation: 0, // AppBar 그림자 제거
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.w300, color: Colors.black),
      displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.w400, color: Colors.black),
      displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.w400, color: Colors.black),
      headlineLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w400, color: Colors.black),
      headlineMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.w400, color: Colors.black),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), // Button text
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black),
    ),

    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF535D5C), // 버튼 배경 색상
      textTheme: ButtonTextTheme.primary, // 버튼 텍스트 색상
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // 버튼 모서리 둥글기 제거 (사각형)
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // 텍스트 색상
        backgroundColor: const Color(0xFF535D5C), // 배경 색상
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // 버튼 모서리 둥글게
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF535D5C), // 텍스트 색상
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF535D5C), // 텍스트 색상
        side: const BorderSide(color: Color(0xFF535D5C)), // 테두리 색상
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100], // 입력 필드 배경 색상
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none, // 테두리 없음
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFF535D5C), width: 2.0), // 포커스 시 테두리 색상
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: Colors.grey[600]),
      labelStyle: TextStyle(color: Colors.grey[800]),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
    ),

    cardTheme: const CardTheme( // ✅ CardTheme으로 다시 변경 (최신 Flutter 버전에서 CardThemeData 대신 CardTheme 사용)
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    ),

    // 기타 위젯 테마 설정 (필요에 따라 추가)
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF535D5C),
      foregroundColor: Colors.white,
    ),

    tabBarTheme: const TabBarTheme( // ✅ TabBarTheme으로 다시 변경
      labelColor: Color(0xFF535D5C), // 선택된 탭 텍스트 색상
      unselectedLabelColor: Colors.grey, // 선택되지 않은 탭 텍스트 색상
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xFF535D5C), width: 2.0),
      ),
    ),
  );
}