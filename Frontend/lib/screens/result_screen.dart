import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import 'dart:convert';
import '../widgets/modern_button.dart';

class ResultScreen extends StatelessWidget {
  final AnalysisResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> probabilities = {};
    try {
      final jsonDetails = jsonDecode(result.details);
      if (jsonDetails['probabilities'] != null) {
        probabilities = jsonDetails['probabilities'];
      }
    } catch (e) {
      // ignore
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2C), // Deep Navy
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Analysis Result', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFFFF9F1C))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFFF9F1C)),
      ),
      body: Container(
        color: const Color(0xFF1A1F2C), // Deep Navy
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Card(
                elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              color: const Color(0xFF232A3A),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: result.severity == 'High' ? Colors.red.withOpacity(0.2) : (result.severity == 'Medium' ? Colors.orange.withOpacity(0.2) : Colors.green.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: result.severity == 'High' ? Colors.red : (result.severity == 'Medium' ? Colors.orange : Colors.green),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, size: 40, color: result.severity == 'High' ? Colors.red : (result.severity == 'Medium' ? Colors.orange : Colors.green)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Severity: ${result.severity}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Based on AI analysis',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '⚠️ NOT A MEDICAL DIAGNOSIS. Informational purposes only.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Divider(color: Colors.white.withOpacity(0.2)),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Probable Causes (AI Estimate):',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9F1C),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...probabilities.entries.map((entry) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${entry.key} (Potential)',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${(entry.value * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    color: Color(0xFFFF9F1C),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: entry.value,
                                minHeight: 10,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  result.severity == 'High' ? Colors.red : const Color(0xFFFF9F1C),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }),
                      if (probabilities.isEmpty)
                        Text(
                          'No detailed probabilities available.',
                          style: TextStyle(color: Colors.white.withOpacity(0.5)),
                        ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9F1C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFF9F1C).withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.lightbulb_outline, color: Color(0xFFFF9F1C)),
                                SizedBox(width: 10),
                                Text(
                                  'Recommendation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF9F1C),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              result.severity == 'High'
                                  ? '🔴 Seek medical attention immediately. Contact emergency services or visit the nearest hospital.'
                                  : (result.severity == 'Medium'
                                      ? '🟡 Consult a healthcare professional. Schedule an appointment with your doctor for a formal check-up.'
                                      : '🟢 Rest, stay hydrated, and monitor your symptoms. If they persist or worsen, consult a doctor.'),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ModernButton(
                        text: 'Back to Home',
                        icon: Icons.home,
                        color: const Color(0xFFFF9F1C), 
                        onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
