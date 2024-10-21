// lib/services/payment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_client.dart';
import '../models/payment.dart';

class PaymentService {
  final apiClient = ApiClient();

  final String baseUrl = 'https://example.com/api'; // Replace with your API URL

  // Add a new payment
  Future<Payment?> addPayment(Payment payment) async {
    final url = Uri.parse('$baseUrl/payments');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payment.toJson()),
    );

    if (response.statusCode == 201) {
      return Payment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to process payment');
    }
  }

  // Get payment by ID
  Future<Payment?> getPayment(int paymentId) async {
    final url = Uri.parse('$baseUrl/payments/$paymentId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Payment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load payment');
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus(int paymentId, String status) async {
    final url = Uri.parse('$baseUrl/payments/$paymentId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update payment status');
    }
  }

  // Delete a payment
  Future<void> deletePayment(int paymentId) async {
    final url = Uri.parse('$baseUrl/payments/$paymentId');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete payment');
    }
  }

  // Get all payments
  Future<List<Payment>> getAllPayments() async {
    final url = Uri.parse('$baseUrl/payments');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Payment.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load payments');
    }
  }
}
