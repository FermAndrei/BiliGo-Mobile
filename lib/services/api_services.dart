import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseURL;

  ApiService({required this.baseURL});

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseURL$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed Get Request: ${response.statusCode}');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseURL$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed POST request: ${response.statusCode}');
    }
  }
}
