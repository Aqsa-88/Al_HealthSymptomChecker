import 'package:flutter/material.dart';
import 'symptom_form_screen.dart';
import 'history_screen.dart';
import 'about_screen.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import '../widgets/modern_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('AI Health Symptom Checker', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFFFF9F1C))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFFF9F1C)),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF232A3A), // Dark card color
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1A1F2C), // Solid dark navy matching login screen
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.health_and_safety, color: Color(0xFFFF9F1C), size: 40),
                  const SizedBox(height: 10),
                  const Text(
                    'AI Health Checker',
                    style: TextStyle(
                      color: Color(0xFFFF9F1C),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'User: ${ApiService.username ?? "Guest"}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Color(0xFFFF9F1C)),
              title: const Text('History', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Color(0xFFFF9F1C)),
              title: const Text('About', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
              },
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                ApiService().logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFF1A1F2C), // Deep Navy - matching login screen
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              color: const Color(0xFF232A3A),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9F1C),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF9F1C).withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.health_and_safety, size: 80, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Welcome, ${ApiService.username ?? "User"}!',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9F1C),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Get AI-assisted health insights instantly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ModernButton(
                        text: 'Check Symptoms',
                        color: const Color(0xFFFF9F1C),
                        icon: Icons.search,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SymptomFormScreen()));
                        },
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Disclaimer: Informational use only. Not a medical diagnosis. Consult a professional.',
                                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
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
}
