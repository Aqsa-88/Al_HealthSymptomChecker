import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../models/symptom.dart';
import '../services/api_service.dart';
import 'result_screen.dart';
import '../models/analysis_result.dart';
import '../widgets/modern_button.dart';

class SymptomFormScreen extends StatefulWidget {
  const SymptomFormScreen({super.key});

  @override
  State<SymptomFormScreen> createState() => _SymptomFormScreenState();
}

class _SymptomFormScreenState extends State<SymptomFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  String _gender = 'Female';
  String _duration = '1-2 days';
  double _painLevel = 5.0;
  final TextEditingController _symptomSearchController = TextEditingController();
  final List<String> _selectedSymptoms = [];
  final ApiService _apiService = ApiService();
  
  List<Symptom> _allSymptoms = [];

  @override
  void initState() {
    super.initState();
    _loadSymptoms();
  }

  Future<void> _loadSymptoms() async {
    final symptoms = await _apiService.getSymptoms();
    setState(() {
      _allSymptoms = symptoms;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedSymptoms.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one symptom')),
        );
        return;
      }

      try {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Analyzing your symptoms...', style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        );

        // Call API
        final result = await _apiService.assessSymptoms(
          age: int.parse(_ageController.text),
          gender: _gender,
          symptoms: _selectedSymptoms,
          duration: _duration,
          painLevel: _painLevel.toInt(),
        );

        // Hide loading
        if (context.mounted) Navigator.pop(context);

        // Navigate to result
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(result: result),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2C), // Deep Navy
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Describe Symptoms', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9F1C))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFFF9F1C)),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 80), // Add padding to push content below the app bar
        color: const Color(0xFF1A1F2C), // Deep Navy
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              color: const Color(0xFF232A3A),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Tell us how you feel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9F1C),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _ageController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Age',
                            labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xFFFF9F1C), width: 2),
                            ),
                            prefixIcon: const Icon(Icons.cake, color: Color(0xFFFF9F1C)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? 'Please enter age' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          items: ['Male', 'Female', 'Other']
                              .map((label) => DropdownMenuItem(
                                    value: label,
                                    child: Text(label, style: const TextStyle(color: Colors.white)),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _gender = value!),
                          dropdownColor: const Color(0xFF232A3A),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xFFFF9F1C), width: 2),
                            ),
                            prefixIcon: const Icon(Icons.person, color: Color(0xFFFF9F1C)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _duration,
                          items: ['1-2 days', '3-7 days', '1-2 weeks', 'More than 2 weeks']
                              .map((label) => DropdownMenuItem(
                                    value: label,
                                    child: Text(label, style: const TextStyle(color: Colors.white)),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _duration = value!),
                          dropdownColor: const Color(0xFF232A3A),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Duration',
                            labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xFFFF9F1C), width: 2),
                            ),
                            prefixIcon: const Icon(Icons.access_time, color: Color(0xFFFF9F1C)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Pain Level: ${_painLevel.toInt()}',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Slider(
                          value: _painLevel,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          activeColor: const Color(0xFFFF9F1C),
                          inactiveColor: Colors.white.withOpacity(0.2),
                          label: _painLevel.toInt().toString(),
                          onChanged: (value) => setState(() => _painLevel = value),
                        ),
                        const SizedBox(height: 16),
                        TypeAheadField<Symptom>(
                          builder: (context, controller, focusNode) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Search and add symptoms',
                                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Color(0xFFFF9F1C), width: 2),
                                ),
                                prefixIcon: const Icon(Icons.search, color: Color(0xFFFF9F1C)),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                              ),
                            );
                          },
                          suggestionsCallback: (pattern) async {
                            if (pattern.isEmpty) return [];
                            return _allSymptoms
                                .where((s) => s.name.toLowerCase().contains(pattern.toLowerCase()))
                                .toList();
                          },
                          itemBuilder: (context, Symptom suggestion) {
                            return ListTile(
                              tileColor: const Color(0xFF232A3A),
                              title: Text(suggestion.name, style: const TextStyle(color: Colors.white)),
                            );
                          },
                          onSelected: (Symptom suggestion) {
                            if (!_selectedSymptoms.contains(suggestion.name)) {
                              setState(() {
                                _selectedSymptoms.add(suggestion.name);
                                _symptomSearchController.clear();
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_selectedSymptoms.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _selectedSymptoms.map((symptom) {
                              return Chip(
                                label: Text(symptom, style: const TextStyle(color: Colors.white)),
                                backgroundColor: const Color(0xFFFF9F1C).withOpacity(0.3),
                                deleteIconColor: Colors.white,
                                side: const BorderSide(color: Color(0xFFFF9F1C)),
                                onDeleted: () {
                                  setState(() {
                                    _selectedSymptoms.remove(symptom);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 24),
                        ModernButton(
                          text: 'Analyze Symptoms',
                          icon: Icons.analytics,
                          color: const Color(0xFFFF9F1C),
                          onPressed: _submitForm,
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