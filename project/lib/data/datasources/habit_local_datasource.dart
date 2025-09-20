import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit_model.dart';

abstract class HabitLocalDataSource {
  Future<List<HabitModel>> getHabits();
  Future<void> saveHabits(List<HabitModel> habits);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  static const String habitsKey = 'habits';

  @override
  Future<List<HabitModel>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString(habitsKey);
    if (habitsJson == null) return [];
    final List<dynamic> decoded = jsonDecode(habitsJson);
    return decoded.map((e) => HabitModel.fromMap(e)).toList();
  }

  @override
  Future<void> saveHabits(List<HabitModel> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(habits.map((e) => e.toMap()).toList());
    await prefs.setString(habitsKey, encoded);
  }
}
