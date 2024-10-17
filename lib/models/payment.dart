class Payment {
  int paymentId;
  double amount;
  String _status; // Private field
  String method;
  DateTime date;

  Payment({
    required this.paymentId,
    required this.amount,
    required String status, // Initialize via constructor
    required this.method,
    required this.date,
  }) : _status = status;

  // Getter for status
  String get status => _status;

  // Setter for status
  set status(String newStatus) {
    _status = newStatus;
  }

  // Factory method to parse JSON
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['paymentId'],
      amount: json['amount'],
      status: json['status'],
      method: json['method'],
      date: DateTime.parse(json['date']),
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'amount': amount,
      'status': _status,
      'method': method,
      'date': date.toIso8601String(),
    };
  }
}
