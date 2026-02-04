import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

class ResultScreen extends StatelessWidget {
  final String severity;
  final String details; // JSON String or plain text

  const ResultScreen({
    super.key,
    required this.severity,
    required this.details,
  });

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getRecommendation(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return 'Rest, hydration, and monitor your symptoms. If they persist, see a doctor.';
      case 'medium':
        return 'Consult a doctor soon. Avoid strenuous activities.';
      case 'high':
      case 'critical':
        return 'Seek medical attention immediately.';
      default:
        return 'Consult a healthcare professional.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(severity);
    final recommendation = _getRecommendation(severity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Result'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Severity Card
            Card(
              color: severityColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: severityColor, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Severity Level',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      severity.toUpperCase(),
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: severityColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Possible Causes
            Text(
              'Possible Causes',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildProbabilities(context),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'These are possible causes, not a diagnosis.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recommendation
            Text(
              'Recommendation',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  recommendation,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black,
              ),
              child: const Text('Check Another Symptom'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProbabilities(BuildContext context) {
    try {
      final Map<String, dynamic> jsonDetails = json.decode(details);
      if (jsonDetails.containsKey('probabilities')) {
        final Map<String, dynamic> probs = jsonDetails['probabilities'];

        return Column(
          children: probs.entries.map((e) {
            final name = e.key;
            // Handle float or double parsing safely
            final double value = (e.value is int)
                ? (e.value as int).toDouble()
                : (e.value as double);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey.shade200,
                    color: value > 0.5
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).primaryColor,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(value * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      }
    } catch (_) {
      // Fallback if parsing fails
    }

    return const Text('• Detail parsing unavailable.');
  }
}
