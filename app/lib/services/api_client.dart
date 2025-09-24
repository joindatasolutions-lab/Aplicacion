import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiClient {
  final String baseUrl;
  ApiClient(this.baseUrl);

  Future<Map<String, String>> _headers() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = user != null ? await user.getIdToken(true) : '';
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
  }

  Future<List<dynamic>> getOrders() async {
    final res = await http.get(Uri.parse('$baseUrl/orders'), headers: await _headers());
    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
    return jsonDecode(res.body) as List;
  }

  Future<List<dynamic>> getAccounts() async {
    final res = await http.get(Uri.parse('$baseUrl/accounts'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Error accounts');
    return jsonDecode(res.body) as List;
  }

  Future<void> updateStatus(String orderId, String status, String? account) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/orders/$orderId/status'),
      headers: await _headers(),
      body: jsonEncode({'status': status, 'account': account})
    );
    if (res.statusCode != 200) throw Exception('Update failed');
  }
}
