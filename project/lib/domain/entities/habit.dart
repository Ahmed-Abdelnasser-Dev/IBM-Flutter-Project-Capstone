class Habit {
  final String name;
  final String colorHex;
  final bool completed;

  Habit({
    required this.name,
    required this.colorHex,
    this.completed = false,
  });

  Habit copyWith({String? name, String? colorHex, bool? completed}) {
    return Habit(
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      completed: completed ?? this.completed,
    );
  }
}
