import '../../domain/entities/habit.dart';

class HabitModel extends Habit {
  HabitModel({
    required super.name,
    required super.colorHex,
    super.completed,
  });

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      name: map['name'],
      colorHex: map['colorHex'],
      completed: map['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'colorHex': colorHex,
      'completed': completed,
    };
  }
}