import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';
import '../../data/models/goal_model.dart';

class GoalsViewModel extends ChangeNotifier {
  final StorageService _storageService;

  List<GoalModel> _goals = [];
  String _filterCategory = 'All';

  GoalsViewModel(this._storageService);

  List<GoalModel> get filteredGoals {
    if (_filterCategory == 'All') return _goals;
    return _goals.where((g) => g.category == _filterCategory).toList();
  }

  String get filterCategory => _filterCategory;

  Future<void> loadGoals() async {
    _goals = _storageService.getGoals();
    notifyListeners();
  }

  void setFilterCategory(String category) {
    _filterCategory = category;
    notifyListeners();
  }

  Future<void> deleteGoal(String goalId) async {
    _goals.removeWhere((g) => g.id == goalId);
    await _storageService.saveGoals(_goals);
    notifyListeners();
  }

  Future<void> toggleGoalComplete(String goalId) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _goals[index] = _goals[index].copyWith(
        completed: !_goals[index].completed,
      );
      await _storageService.saveGoals(_goals);
      notifyListeners();
    }
  }
}
