import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';
import '../../data/models/goal_model.dart';

class GoalDetailViewModel extends ChangeNotifier {
  final StorageService _storageService;

  GoalModel? _goal;

  GoalDetailViewModel(this._storageService);

  GoalModel? get goal => _goal;

  Future<void> loadGoal(String goalId) async {
    final goals = _storageService.getGoals();
    _goal = goals.firstWhere(
      (g) => g.id == goalId,
      orElse: () => GoalModel(name: '', amount: 0, category: ''),
    );
    notifyListeners();
  }

  Future<void> deleteGoal(String goalId) async {
    final goals = _storageService.getGoals();
    goals.removeWhere((g) => g.id == goalId);
    await _storageService.saveGoals(goals);
    notifyListeners();
  }
}
