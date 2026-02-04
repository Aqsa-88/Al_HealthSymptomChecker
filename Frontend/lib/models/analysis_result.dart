class AnalysisResult {
  final String severity;
  final String details;

  AnalysisResult({required this.severity, required this.details});

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      severity: json['severity'] ?? 'Unknown',
      details: json['details'] ?? '{}',
    );
  }
}
