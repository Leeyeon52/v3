// C:\Users\user\Desktop\0703flutter_v2\lib\features\mypage\view\remote_diagnosis_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'remote_diagnosis_history_screen.dart'; // RemoteDiagnosisRecord 모델 사용을 위해 임포트

class RemoteDiagnosisDetailScreen extends StatelessWidget {
  final RemoteDiagnosisRecord record;

  const RemoteDiagnosisDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비대면 진료 상세'),
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
              '요청일: ${DateFormat('yyyy년 MM월 dd일 HH:mm').format(record.requestDate)}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.medical_services, color: Colors.blueAccent),
                const SizedBox(width: 10),
                Text(
                  record.doctorName != null ? '진료 의사: ${record.doctorName} 선생님' : '아직 답변이 없습니다.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              '현재 상태: ${record.status}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: record.status == '답변 완료'
                    ? Colors.green[700]
                    : record.status == '대기중'
                        ? Colors.orange[700]
                        : Colors.red[700],
              ),
            ),
            const SizedBox(height: 20),
            if (record.doctorComment != null) ...[
              const Text(
                '의사 소견:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueGrey[200]!),
                ),
                child: Text(
                  record.doctorComment!,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: const Text(
                  '의사 선생님의 답변을 기다리고 있습니다. 답변이 완료되면 알림으로 알려드릴게요.',
                  style: TextStyle(fontSize: 16, height: 1.5, color: Colors.orange),
                ),
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: record.status == '답변 완료'
                    ? () {
                        // TODO: 병원 예약으로 바로 이동하거나, 이 소견을 바탕으로 병원 추천 등
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('이 소견을 바탕으로 병원 찾기 또는 예약 기능 구현 예정')),
                        );
                      }
                    : null, // 답변 완료 상태가 아니면 버튼 비활성화
                icon: const Icon(Icons.calendar_today_outlined),
                label: const Text('진료 소견 기반 병원 예약하기'),
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
                  // TODO: 진료 내역 삭제/취소 기능
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('진료 내역 삭제/취소 기능 구현 예정')),
                  );
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('진료 내역 삭제/취소'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}