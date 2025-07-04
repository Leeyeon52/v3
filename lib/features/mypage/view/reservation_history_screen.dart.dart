// C:\Users\user\Desktop\0703flutter_v2\lib\features\mypage\view\reservation_history_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// 가상의 병원 예약 기록 모델
class ReservationRecord {
  final String id;
  final String hospitalName;
  final DateTime reservationDate;
  final String status; // '예약 확정', '예약 대기', '예약 취소', '진료 완료'
  final String? notes;

  ReservationRecord({
    required this.id,
    required this.hospitalName,
    required this.reservationDate,
    required this.status,
    this.notes,
  });
}

class ReservationHistoryScreen extends StatefulWidget {
  const ReservationHistoryScreen({super.key});

  @override
  State<ReservationHistoryScreen> createState() => _ReservationHistoryScreenState();
}

class _ReservationHistoryScreenState extends State<ReservationHistoryScreen> {
  List<ReservationRecord> _records = [
    ReservationRecord(
      id: 'RES001',
      hospitalName: '서울튼튼치과',
      reservationDate: DateTime(2025, 7, 10, 14, 0),
      status: '예약 확정',
      notes: '충치 검진 및 스케일링',
    ),
    ReservationRecord(
      id: 'RES002',
      hospitalName: '우리동네치과',
      reservationDate: DateTime(2025, 7, 5, 10, 30),
      status: '진료 완료',
      notes: '정기 검진',
    ),
    ReservationRecord(
      id: 'RES003',
      hospitalName: '미소치과',
      reservationDate: DateTime(2025, 7, 15, 16, 0),
      status: '예약 대기',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('병원 예약 내역'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _records.isEmpty
          ? const Center(child: Text('병원 예약 내역이 없습니다.'))
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
                      // TODO: 예약 상세 화면으로 이동하거나, 예약 변경/취소 팝업 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${record.hospitalName} 예약 상세 보기 기능 구현 예정')),
                      );
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
                              Expanded(
                                child: Text(
                                  record.hospitalName,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: record.status == '예약 확정' || record.status == '진료 완료'
                                      ? Colors.green[100]
                                      : record.status == '예약 대기'
                                          ? Colors.orange[100]
                                          : Colors.red[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  record.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: record.status == '예약 확정' || record.status == '진료 완료'
                                        ? Colors.green[700]
                                        : record.status == '예약 대기'
                                            ? Colors.orange[700]
                                            : Colors.red[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '날짜: ${DateFormat('yyyy년 MM월 dd일 HH:mm').format(record.reservationDate)}',
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          if (record.notes != null && record.notes!.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Text(
                              '메모: ${record.notes!}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                // TODO: 예약 취소/변경 등 옵션 팝업
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('예약 관리 옵션 메뉴 구현 예정')),
                                );
                              },
                            ),
                          ),
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