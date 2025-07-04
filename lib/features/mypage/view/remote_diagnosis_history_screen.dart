// C:\Users\user\Desktop\0703flutter_v2\lib\features\mypage\view\remote_diagnosis_history_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// 가상의 비대면 진료 기록 모델
class RemoteDiagnosisRecord {
  final String id;
  final DateTime requestDate;
  final String status; // '대기중', '답변 완료', '취소'
  final String? doctorName;
  final String? doctorComment;

  RemoteDiagnosisRecord({
    required this.id,
    required this.requestDate,
    required this.status,
    this.doctorName,
    this.doctorComment,
  });
}

class RemoteDiagnosisHistoryScreen extends StatefulWidget {
  const RemoteDiagnosisHistoryScreen({super.key});

  @override
  State<RemoteDiagnosisHistoryScreen> createState() => _RemoteDiagnosisHistoryScreenState();
}

class _RemoteDiagnosisHistoryScreenState extends State<RemoteDiagnosisHistoryScreen> {
  List<RemoteDiagnosisRecord> _records = [
    RemoteDiagnosisRecord(
      id: 'RD001',
      requestDate: DateTime(2025, 7, 1, 15, 0),
      status: '답변 완료',
      doctorName: '김의사',
      doctorComment: '사진 상으로는 충치 초기 단계로 보입니다. 정확한 진단을 위해 내원하시는 것이 좋습니다.',
    ),
    RemoteDiagnosisRecord(
      id: 'RD002',
      requestDate: DateTime(2025, 6, 28, 10, 30),
      status: '대기중',
    ),
    RemoteDiagnosisRecord(
      id: 'RD003',
      requestDate: DateTime(2025, 6, 20, 11, 0),
      status: '답변 완료',
      doctorName: '박의사',
      doctorComment: '잇몸 건강은 양호해 보이나, 정기적인 스케일링을 권장합니다.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비대면 진료 내역'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _records.isEmpty
          ? const Center(child: Text('비대면 진료 요청 내역이 없습니다.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      context.go('/remote-diagnosis-detail', extra: record);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '요청일: ${DateFormat('yyyy년 MM월 dd일 HH:mm').format(record.requestDate)}',
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: record.status == '답변 완료'
                                      ? Colors.green[100]
                                      : record.status == '대기중'
                                          ? Colors.orange[100]
                                          : Colors.red[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  record.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: record.status == '답변 완료'
                                        ? Colors.green[700]
                                        : record.status == '대기중'
                                            ? Colors.orange[700]
                                            : Colors.red[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            record.doctorName != null
                                ? '의사: ${record.doctorName} 선생님'
                                : '의사 답변 대기 중',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          if (record.doctorComment != null) ...[
                            const SizedBox(height: 5),
                            Text(
                              record.doctorComment!,
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}