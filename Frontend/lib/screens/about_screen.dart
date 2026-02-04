import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2C), // Deep Navy
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('About & Ethics', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFFFF9F1C))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFFF9F1C)),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: const Color(0xFF1A1F2C), // Deep Navy
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              color: const Color(0xFF232A3A),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.health_and_safety, color: Color(0xFFFF9F1C), size: 32),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'AI Health Symptom Checker',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF9F1C),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        'Purpose',
                        'This application is an educational AI project designed to demonstrate how symptom-based assessment can be assisted by technology. It is NOT a professional medical tool.',
                        Icons.info_outline,
                      ),
                      const SizedBox(height: 20),
                      _buildSection(
                        'Medical Ethics & Safety',
                        '1. AI is assistive, NOT diagnostic. Only a licensed doctor can provide a diagnosis.\n\n2. In case of emergency, do not wait for AI results; seek immediate help.\n\n3. Always consult with healthcare professionals for proper medical advice.',
                        Icons.warning_amber_rounded,
                      ),
                      const SizedBox(height: 20),
                      _buildSection(
                        'Data Privacy',
                        'We value your privacy. Your age, gender, and symptoms are stored securely in your history to help you track your health over time. Data is not shared with third parties.',
                        Icons.lock_outline,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9F1C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFF9F1C).withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified_user, color: Color(0xFFFF9F1C)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your health and safety are our top priorities. This tool is designed to assist, not replace, professional medical care.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFFF9F1C), size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9F1C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
