// lib/features/diagnosis/viewmodel/diagnosis_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // File 클래스를 위해 필요
import 'package:http/http.dart' as http;
import 'dart:convert';

// 진단 결과를 위한 모델 (임시, 실제 모델은 diagnosis_result.dart에 정의)
class DiagnosisResult {
  final String diagnosis;
  final String confidence;
  final String imageUrl;

  DiagnosisResult({
    required this.diagnosis,
    required this.confidence,
    required this.imageUrl,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      diagnosis: json['diagnosis'] ?? '알 수 없음',
      confidence: json['confidence'] ?? 'N/A',
      imageUrl: json['imageUrl'] ?? '', // 이미지 URL은 필요에 따라 추가
    );
  }
}

class DiagnosisViewModel extends ChangeNotifier {
  File? _selectedImage;
  DiagnosisResult? _diagnosisResult;
  bool _isLoading = false;
  String? _errorMessage;

  File? get selectedImage => _selectedImage;
  DiagnosisResult? get diagnosisResult => _diagnosisResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 이미지 선택 (갤러리 또는 카메라)
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      _errorMessage = null; // 새로운 이미지 선택 시 오류 메시지 초기화
      notifyListeners();
    }
  }

  // 이미지 업로드 및 진단 요청
  Future<void> uploadImageForDiagnosis() async {
    if (_selectedImage == null) {
      _errorMessage = '진단할 이미지를 선택해주세요.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: 실제 서버 엔드포인트로 변경해야 합니다.
      // 현재는 더미 응답을 반환하도록 구현
      // final uri = Uri.parse('YOUR_DIAGNOSIS_API_ENDPOINT');
      // var request = http.MultipartRequest('POST', uri)
      //   ..files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));
      // var response = await request.send();

      // if (response.statusCode == 200) {
      //   final responseBody = await response.stream.bytesToString();
      //   final jsonResponse = json.decode(responseBody);
      //   _diagnosisResult = DiagnosisResult.fromJson(jsonResponse);
      // } else {
      //   _errorMessage = '진단 서버 오류: ${response.statusCode}';
      // }

      // 더미 데이터로 진단 결과 시뮬레이션
      await Future.delayed(const Duration(seconds: 2)); // 네트워크 요청 시뮬레이션
      _diagnosisResult = DiagnosisResult(
        diagnosis: '충치 초기 단계',
        confidence: '85%',
        imageUrl: _selectedImage!.path, // 선택된 이미지를 결과 이미지로 사용
      );
    } catch (e) {
      _errorMessage = '이미지 업로드 및 진단 중 오류 발생: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 진단 결과 초기화 (새로운 진단을 위해)
  void resetDiagnosis() {
    _selectedImage = null;
    _diagnosisResult = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
