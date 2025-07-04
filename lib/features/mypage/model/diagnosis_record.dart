class DiagnosisRecord {
  final String id;
  final DateTime date;
  final String type; // 충치, 치주염 등
  final String result; // 초기 충치 발견, 잇몸 염증 소견 등
  final String imageUrl; // 진단에 사용된 이미지 URL 또는 로컬 경로
  final String? detail; // 상세 설명 (옵션)

  DiagnosisRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.result,
    required this.imageUrl,
    this.detail,
  });
}

class RemoteDiagnosisRecord {
  final String id;
  final DateTime date;
  final String type; // 구강 검진 요청, 통증 상담 등
  final String status; // 진행 중, 완료 등
  final String? doctorComment; // 의사 코멘트 (옵션)
  final String imageUrl; // 진료에 사용된 이미지 URL 또는 로컬 경로 (선택 사항)

  RemoteDiagnosisRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.status,
    this.doctorComment,
    required this.imageUrl,
  });
}