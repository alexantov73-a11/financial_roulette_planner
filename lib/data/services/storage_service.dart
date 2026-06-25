import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../models/goal_model.dart';

class StorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User
  Future<void> saveUser(UserModel user) async {
    await _prefs.setString('user', jsonEncode(user.toJson()));
  }

  UserModel? getUser() {
    final json = _prefs.getString('user');
    if (json == null) return null;
    return UserModel.fromJson(json);
  }

  // Goals
  Future<void> saveGoals(List<GoalModel> goals) async {
    final json = jsonEncode(goals.map((g) => g.toJson()).toList());
    await _prefs.setString('goals', json);
  }

  List<GoalModel> getGoals() {
    final json = _prefs.getString('goals');
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((g) => GoalModel.fromJson(jsonEncode(g))).toList();
  }

  // Dark Mode
  bool isDarkMode() => _prefs.getBool('dark_mode') ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('dark_mode', value);
  }

  // Clear
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
