import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_request.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<UserRequest>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _apiService.getHistory();
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'emergency':
        return Colors.red.shade900;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2C), // Deep Navy
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Assessment History', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFFFF9F1C))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFFF9F1C)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {
              _historyFuture = _apiService.getHistory();
            }),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF1A1F2C), // Deep Navy
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
          children: [
            // Spacer for AppBar
            const SizedBox(height: kToolbarHeight + 20),
            // Session Debug Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF232A3A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFF9F1C).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 14, color: Color(0xFFFF9F1C)),
                  const SizedBox(width: 4),
                  Text(
                    'User: ${ApiService.username ?? "Unknown"}',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    ApiService.token != null ? Icons.check_circle : Icons.cancel,
                    size: 14,
                    color: ApiService.token != null ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ApiService.token != null ? 'Authenticated' : 'Not Authenticated',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<UserRequest>>(
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFF9F1C)),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          color: const Color(0xFF232A3A),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                                const SizedBox(height: 16),
                                Text(
                                  'Error loading history',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  snapshot.error.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final history = snapshot.data ?? [];

                  if (history.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 80, color: Colors.white.withOpacity(0.3)),
                          const SizedBox(height: 16),
                          Text(
                            'No assessment history yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start by checking your symptoms',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final dateStr = item.createdAt != null
                          ? DateFormat('MMM dd, yyyy - hh:mm a').format(item.createdAt!)
                          : 'Unknown date';

                      return Card(
                        elevation: 6,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        color: const Color(0xFF232A3A),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            _showHistoryDetails(context, item);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getSeverityColor(item.severity ?? 'Unknown').withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _getSeverityColor(item.severity ?? 'Unknown'),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        item.severity ?? 'Unknown',
                                        style: TextStyle(
                                          color: _getSeverityColor(item.severity ?? 'Unknown'),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.5)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.medical_services, size: 16, color: Color(0xFFFF9F1C)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.symptoms.join(', '),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 14, color: Colors.white.withOpacity(0.5)),
                                    const SizedBox(width: 6),
                                    Text(
                                      dateStr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }

  void _showHistoryDetails(BuildContext context, UserRequest item) {
    final dateStr = item.createdAt != null
        ? DateFormat('MMMM dd, yyyy at hh:mm a').format(item.createdAt!)
        : 'Unknown date';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232A3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFFF9F1C)),
            const SizedBox(width: 10),
            const Text('Assessment Details', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Date', dateStr),
              const SizedBox(height: 12),
              _detailRow('Severity', item.severity ?? 'Unknown'),
              const SizedBox(height: 12),
              _detailRow('Age', item.age.toString()),
              const SizedBox(height: 12),
              _detailRow('Gender', item.gender),
              const SizedBox(height: 12),
              _detailRow('Duration', item.duration),
              const SizedBox(height: 12),
              _detailRow('Pain Level', item.painLevel.toString()),
              const SizedBox(height: 12),
              const Text(
                'Symptoms:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9F1C)),
              ),
              const SizedBox(height: 6),
              ...item.symptoms.map((s) => Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(child: Text(s, style: const TextStyle(color: Colors.white))),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFFFF9F1C))),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9F1C)),
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}