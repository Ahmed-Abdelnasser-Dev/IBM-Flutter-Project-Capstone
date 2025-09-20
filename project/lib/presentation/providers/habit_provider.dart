import 'package:flutter/material.dart';
import '../../data/datasources/habit_local_datasource.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';

class HabitProvider extends ChangeNotifier {
  final HabitRepository _habitRepository =
      HabitRepositoryImpl(HabitLocalDataSourceImpl());

  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HabitProvider() {
    loadHabits();
  }

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();
    _habits = await _habitRepository.getHabits();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await _habitRepository.addHabit(habit);
    await loadHabits();
  }

  Future<void> deleteHabit(String name) async {
    await _habitRepository.deleteHabit(name);
    await loadHabits();
  }

  Future<void> completeHabit(String name) async {
    await _habitRepository.completeHabit(name);
    await loadHabits();
  }
}
