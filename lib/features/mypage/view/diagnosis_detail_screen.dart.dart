// C:\Users\user\Desktop\0703flutter_v2\lib\features\mypage\view\diagnosis_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'diagnosis_history_screen.dart'; // DiagnosisRecord 모델 사용을 위해 임포트

class DiagnosisDetailScreen extends StatelessWidget {
  final DiagnosisRecord record; // 이전 화면에서 전달받을 진단 기록 데이터

  const DiagnosisDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('진단 내역 상세'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.summary,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '진단일: ${DateFormat('yyyy년 MM월 dd일 HH:mm').format(record.date)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  record.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 150, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '상세 진단 결과:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                record.detail,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: 이 진단 기록을 기반으로 비대면 진료 신청 로직 추가
                  // 예를 들어, context.go('/remote-diagnosis-request', extra: record.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('비대면 진료 신청 페이지로 이동합니다.')),
                  );
                },
                icon: const Icon(Icons.medical_services_outlined),
                label: const Text('이 진단으로 비대면 진료 신청하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: 진단 결과 공유 기능 추가
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('진단 결과 공유 기능 구현 예정')),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('진단 결과 공유하기'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}