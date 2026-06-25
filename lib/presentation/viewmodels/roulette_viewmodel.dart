import 'package:flutter/material.dart';
import 'dart:math';

class RouletteViewModel extends ChangeNotifier {
  double _totalAmount = 0;
  List<String> _selectedCategories = [];
  Map<String, double> _allocations = {};
  bool _isSpinning = false;

  RouletteViewModel();

  double get totalAmount => _totalAmount;
  List<String> get selectedCategories => _selectedCategories;
  Map<String, double> get allocations => _allocations;
  bool get isSpinning => _isSpinning;

  void setTotalAmount(double amount) {
    _totalAmount = amount;
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  Future<void> spinRoulette() async {
    if (_selectedCategories.isEmpty || _totalAmount <= 0) return;

    _isSpinning = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 2000));

    _allocations = {};
    final random = Random();

    // Генерируем случайные веса (всегда положительные) для каждой категории
    final weights = _selectedCategories
        .map((_) => random.nextDouble() + 0.05)
        .toList();
    final totalWeight = weights.reduce((a, b) => a + b);

    double allocatedSoFar = 0;
    for (int i = 0; i < _selectedCategories.length; i++) {
      if (i == _selectedCategories.length - 1) {
        // Последней категории отдаём точный остаток —
        // так сумма всех долей всегда равна totalAmount без ошибок округления
        _allocations[_selectedCategories[i]] = _totalAmount - allocatedSoFar;
      } else {
        final amount = _totalAmount * (weights[i] / totalWeight);
        _allocations[_selectedCategories[i]] = amount;
        allocatedSoFar += amount;
      }
    }

    _isSpinning = false;
    notifyListeners();
  }

  void reset() {
    _totalAmount = 0;
    _selectedCategories = [];
    _allocations = {};
    notifyListeners();
  }
}
