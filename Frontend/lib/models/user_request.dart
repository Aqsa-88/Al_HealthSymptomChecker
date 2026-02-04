import 'dart:convert';

class UserRequest {
  final int id;
  final int? userId;
  final String symptomsList;
  final String duration;
  final int painLevel;
  final String predictedSeverity;
  final String aiResponseJson;
  final DateTime timestamp;
  final int age;
  final String gender;

  UserRequest({
    required this.id,
    this.userId,
    required this.symptomsList,
    required this.duration,
    required this.painLevel,
    required this.predictedSeverity,
    required this.aiResponseJson,
    required this.timestamp,
    required this.age,
    required this.gender,
  });

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    // Helper to get value regardless of case
    dynamic val(String key) => json[key] ?? json[key[0].toUpperCase() + key.substring(1)];

    return UserRequest(
      id: val('id') ?? 0,
      userId: val('userId'),
      symptomsList: val('symptomsList')?.toString() ?? '',
      duration: val('duration')?.toString() ?? '',
      painLevel: val('painLevel') is int ? val('painLevel') : int.tryParse(val('painLevel')?.toString() ?? '0') ?? 0,
      predictedSeverity: val('predictedSeverity')?.toString() ?? 'Unknown',
      aiResponseJson: val('aiResponseJson')?.toString() ?? '{}',
      timestamp: DateTime.parse(val('timestamp') ?? DateTime.now().toIso8601String()),
      age: val('age') is int ? val('age') : int.tryParse(val('age')?.toString() ?? '0') ?? 0,
      gender: val('gender')?.toString() ?? 'Unknown',
    );
  }

  List<String> get symptoms => symptomsList.split(',').where((s) => s.isNotEmpty).toList();

  Map<String, dynamic> get aiDetails {
    try {
      return jsonDecode(aiResponseJson);
    } catch (e) {
      return {};
    }
  }

  // Getters for compatibility with history screen
  String? get severity => predictedSeverity;
  DateTime? get createdAt => timestamp;
}
