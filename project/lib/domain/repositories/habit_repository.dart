import '../entities/habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> getHabits();
  Future<void> addHabit(Habit habit);
  Future<void> deleteHabit(String name);
  Future<void> completeHabit(String name);
}
