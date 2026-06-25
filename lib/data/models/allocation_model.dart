import 'dart:convert';

class AllocationModel {
  final Map<String, double> allocations;
  final double totalAmount;
  final DateTime createdAt;

  AllocationModel({
    required this.allocations,
    required this.totalAmount,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'allocations': allocations,
    'totalAmount': totalAmount,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AllocationModel.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    return AllocationModel(
      allocations: Map<String, double>.from(data['allocations']),
      totalAmount: (data['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(data['createdAt']),
    );
  }
}
