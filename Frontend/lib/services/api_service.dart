import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html; // Add this for web persistence
import '../models/symptom.dart';
import '../models/analysis_result.dart';
import '../models/user_request.dart';

class ApiService {
  final String baseUrl = "http://localhost:5000/api";
  
  static String? get _token => html.window.localStorage['jwt_token'];
  static set _token(String? value) {
    if (value == null) {
      html.window.localStorage.remove('jwt_token');
    } else {
      html.window.localStorage['jwt_token'] = value;
    }
  }

  static String? get username => html.window.localStorage['username'];
  static set _username(String? value) {
    if (value == null) {
      html.window.localStorage.remove('username');
    } else {
      html.window.localStorage['username'] = value;
    }
  }

  static String? get token => _token;

  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _username = data['username'];
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _token = null;
    _username = null;
  }

  Future<List<Symptom>> getSymptoms() async {
    // Mock for initial testing if backend fails
    /* return [
      Symptom(id: 1, name: "Headache"),
      Symptom(id: 2, name: "Fever")
    ]; */
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/symptom'),
        headers: _token != null ? {'Authorization': 'Bearer $_token'} : {},
      );
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Symptom.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load symptoms');
      }
    } catch (e) {
      // Fallback if API is unreachable
      return [
        Symptom(id: 1, name: "Headache"),
        Symptom(id: 2, name: "Fever"),
        Symptom(id: 3, name: "Nausea"),
        Symptom(id: 4, name: "Dizziness"),
      ];
    }
  }

  Future<AnalysisResult> assessSymptoms({
    required int age,
    required String gender,
    required List<String> symptoms,
    required String duration,
    required int painLevel,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/assessment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'age': age,
        'gender': gender,
        'symptoms': symptoms,
        'duration': duration,
        'painLevel': painLevel,
      }),
    );

    if (response.statusCode == 200) {
      return AnalysisResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to assess symptoms');
    }
  }

  Future<List<UserRequest>> getHistory() async {
    print("DEBUG: Fetching history. Token exists: ${_token != null}");
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/assessment/history'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
      );

      print("DEBUG: History response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        print("DEBUG: History items found: ${body.length}");
        return body.map((dynamic item) => UserRequest.fromJson(item)).toList();
      } else {
        print("DEBUG: History load failed body: ${response.body}");
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      print("DEBUG: History error: $e");
      throw Exception('Error loading history: $e');
    }
  }
}
