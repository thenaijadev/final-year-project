import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AiResponse {
  final String? responseText;
  AiResponse({
    required this.responseText,
  });

  AiResponse copyWith({
    String? responseText,
  }) {
    return AiResponse(
      responseText: responseText ?? this.responseText,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'responseText': responseText,
    };
  }

  factory AiResponse.fromMap(Map<String, dynamic> map) {
    return AiResponse(
      responseText: (map['responseText'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AiResponse.fromJson(String source) =>
      AiResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AiResponse(responseText: $responseText)';

  @override
  bool operator ==(covariant AiResponse other) {
    if (identical(this, other)) return true;

    return other.responseText == responseText;
  }

  @override
  int get hashCode => responseText.hashCode;
}
