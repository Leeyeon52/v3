class User {
  final String email; // 추가: 이메일 필드 (필수)
  final String? name;
  final String? phone;

  User({
    required this.email, // 필수 파라미터로 변경
    this.name,
    this.phone,
  });

  // copyWith 메서드 추가
  User copyWith({
    String? email,
    String? name,
    String? phone,
  }) {
    return User(
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}