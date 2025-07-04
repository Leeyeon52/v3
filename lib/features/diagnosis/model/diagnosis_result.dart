// lib/features/diagnosis/model/diagnosis_result.dart
class DiagnosisResult {
  final String diagnosis;
  final String confidence;
  final String imageUrl; // 진단에 사용된 이미지 URL 또는 결과 이미지 URL

  DiagnosisResult({
    required this.diagnosis,
    required this.confidence,
    required this.imageUrl,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      diagnosis: json['diagnosis'] ?? '알 수 없음',
      confidence: json['confidence'] ?? 'N/A',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diagnosis': diagnosis,
      'confidence': confidence,
      'imageUrl': imageUrl,
    };
  }
}
