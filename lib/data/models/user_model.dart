import 'dart:convert';
import 'package:uuid/uuid.dart';

class UserModel {
  final String id;
  final String? name;
  final String? photoPath;
  final bool onboardingCompleted;
  final DateTime createdAt;

  UserModel({
    String? id,
    this.name,
    this.photoPath,
    this.onboardingCompleted = false,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'photoPath': photoPath,
    'onboardingCompleted': onboardingCompleted,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    return UserModel(
      id: data['id'],
      name: data['name'],
      photoPath: data['photoPath'],
      onboardingCompleted: data['onboardingCompleted'] ?? false,
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  UserModel copyWith({
    String? name,
    String? photoPath,
    bool? onboardingCompleted,
  }) => UserModel(
    id: id,
    name: name ?? this.name,
    photoPath: photoPath ?? this.photoPath,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    createdAt: createdAt,
  );
}
