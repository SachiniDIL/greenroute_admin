// lib/providers/payment_provider.dart
import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  List<Payment> _payments = [];
  final PaymentService _paymentService = PaymentService();

  List<Payment> get payments => _payments;

  // Fetch all payments
  Future<void> fetchPayments() async {
    try {
      _payments = await _paymentService.getAllPayments();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Add a new payment
  Future<void> addPayment(Payment newPayment) async {
    try {
      final payment = await _paymentService.addPayment(newPayment);
      if (payment != null) {
        _payments.add(payment);
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus(int paymentId, String status) async {
    try {
      await _paymentService.updatePaymentStatus(paymentId, status);
      final index = _payments.indexWhere((payment) => payment.paymentId == paymentId);
      if (index != -1) {
        _payments[index].status = status; // Ensure status field exists in the Payment model
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
