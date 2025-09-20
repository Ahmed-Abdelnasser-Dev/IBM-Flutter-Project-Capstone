import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_local_datasource.dart';
import '../models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource localDataSource;

  HabitRepositoryImpl(this.localDataSource);

  @override
  Future<List<Habit>> getHabits() async {
    return await localDataSource.getHabits();
  }

  @override
  Future<void> addHabit(Habit habit) async {
    final habits = await localDataSource.getHabits();
    habits.add(HabitModel(
      name: habit.name,
      colorHex: habit.colorHex,
      completed: habit.completed,
    ));
    await localDataSource.saveHabits(habits.cast<HabitModel>());
  }

  @override
  Future<void> deleteHabit(String name) async {
    final habits = await localDataSource.getHabits();
    habits.removeWhere((h) => h.name == name);
    await localDataSource.saveHabits(habits.cast<HabitModel>());
  }

  @override
  Future<void> completeHabit(String name) async {
    final habits = await localDataSource.getHabits();
    final updatedHabits = habits.map((h) {
      if (h.name == name) {
        return HabitModel(
          name: h.name,
          colorHex: h.colorHex,
          completed: true,
        );
      }
      return h;
    }).toList();
    await localDataSource.saveHabits(updatedHabits.cast<HabitModel>());
  }
}
