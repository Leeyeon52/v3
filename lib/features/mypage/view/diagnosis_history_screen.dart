// C:\Users\user\Desktop\0703flutter_v2\lib\features\mypage\view\diagnosis_history_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가

// 가상의 진단 기록 모델 (실제로는 ToothImage 등을 활용)
class DiagnosisRecord {
  final String id;
  final String imageUrl;
  final DateTime date;
  final String summary;
  final String detail;

  DiagnosisRecord({
    required this.id,
    required this.imageUrl,
    required this.date,
    required this.summary,
    required this.detail,
  });
}

class DiagnosisHistoryScreen extends StatefulWidget {
  const DiagnosisHistoryScreen({super.key});

  @override
  State<DiagnosisHistoryScreen> createState() => _DiagnosisHistoryScreenState();
}

class _DiagnosisHistoryScreenState extends State<DiagnosisHistoryScreen> {
  // TODO: 실제 ViewModel에서 데이터 로드
  List<DiagnosisRecord> _allRecords = [
    DiagnosisRecord(id: '1', imageUrl: 'https://placehold.co/100x70/png?text=Diag1', date: DateTime(2025, 6, 25, 10, 30), summary: '충치 의심 (좌측 어금니)', detail: 'AI 분석 결과 좌측 어금니에 초기 충치가 의심됩니다. 치과 방문을 권장합니다.'),
    DiagnosisRecord(id: '2', imageUrl: 'https://placehold.co/100x70/png?text=Diag2', date: DateTime(2025, 6, 20, 14, 00), summary: '잇몸 염증 가능성', detail: '잇몸이 붉고 부어오른 부분이 관찰됩니다. 칫솔질 시 출혈이 있는지 확인해보세요.'),
    DiagnosisRecord(id: '3', imageUrl: 'https://placehold.co/100x70/png?text=Diag3', date: DateTime(2025, 6, 15, 09, 15), summary: '정상', detail: '전반적으로 양호한 구강 상태입니다. 꾸준히 관리해주세요.'),
    DiagnosisRecord(id: '4', imageUrl: 'https://placehold.co/100x70/png?text=Diag4', date: DateTime(2025, 5, 10, 11, 45), summary: '치석 의심', detail: '치아와 잇몸 경계부에 치석이 관찰됩니다. 스케일링을 고려해보세요.'),
  ];
  List<DiagnosisRecord> _filteredRecords = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredRecords = _allRecords; // 초기에는 모든 기록 표시
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRecords(String query) {
    setState(() {
      _filteredRecords = _allRecords.where((record) {
        return record.summary.toLowerCase().contains(query.toLowerCase()) ||
               record.detail.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _filteredRecords = _allRecords.where((record) =>
            record.date.year == picked.year &&
            record.date.month == picked.month &&
            record.date.day == picked.day
        ).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('진단 내역 조회'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '키워드 검색 (예: 충치, 잇몸)',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                    onChanged: _filterRecords,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                  onPressed: _showDatePicker,
                  tooltip: '날짜별 필터링',
                ),
                // TODO: 정렬 기능 추가 (최신순, 오래된순 등)
              ],
            ),
          ),
          Expanded(
            child: _filteredRecords.isEmpty
                ? const Center(child: Text('검색 결과가 없습니다.'))
                : ListView.builder(
                    itemCount: _filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = _filteredRecords[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          onTap: () {
                            // 상세 화면으로 이동
                            context.go('/diagnosis-history-detail', extra: record);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    record.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        record.summary,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('yyyy년 MM월 dd일 HH:mm').format(record.date),
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        record.detail,
                                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}