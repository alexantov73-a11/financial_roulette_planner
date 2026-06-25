import 'dart:convert';
import 'package:uuid/uuid.dart';

class GoalModel {
  final String id;
  final String name;
  final double amount;
  final String category;
  final String? photoPath;
  final DateTime createdAt;
  final bool completed;

  GoalModel({
    String? id,
    required this.name,
    required this.amount,
    required this.category,
    this.photoPath,
    DateTime? createdAt,
    this.completed = false,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'amount': amount,
    'category': category,
    'photoPath': photoPath,
    'createdAt': createdAt.toIso8601String(),
    'completed': completed,
  };

  factory GoalModel.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    return GoalModel(
      id: data['id'],
      name: data['name'],
      amount: (data['amount'] as num).toDouble(),
      category: data['category'],
      photoPath: data['photoPath'],
      createdAt: DateTime.parse(data['createdAt']),
      completed: data['completed'] ?? false,
    );
  }

  GoalModel copyWith({
    String? name,
    double? amount,
    String? category,
    String? photoPath,
    bool? completed,
  }) => GoalModel(
    id: id,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    photoPath: photoPath ?? this.photoPath,
    createdAt: createdAt,
    completed: completed ?? this.completed,
  );
}
