import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibm_habit_tracker/presentation/providers/habit_provider.dart';
import 'package:ibm_habit_tracker/presentation/screens/add_habit_screen.dart';
import 'package:ibm_habit_tracker/presentation/screens/login_screen.dart';
import 'package:ibm_habit_tracker/presentation/screens/personal_info_screen.dart';
import 'package:ibm_habit_tracker/presentation/screens/reports_screen.dart';
import 'package:ibm_habit_tracker/presentation/screens/notifications_screen.dart';

class HabitTrackerScreen extends StatelessWidget {
	final String username;
	const HabitTrackerScreen({super.key, required this.username});

	@override
	Widget build(BuildContext context) {
		final habitProvider = Provider.of<HabitProvider>(context);
		final name = username;
		final selectedHabits = habitProvider.habits.where((h) => !h.completed).toList();
		final completedHabits = habitProvider.habits.where((h) => h.completed).toList();

		return Scaffold(
			appBar: AppBar(
				backgroundColor: Colors.blue.shade700,
				title: Text(
					name.isNotEmpty ? name : 'Loading...',
					style: const TextStyle(
						fontSize: 24,
						color: Colors.white,
						fontWeight: FontWeight.bold,
					),
				),
				automaticallyImplyLeading: true,
			),
			drawer: Drawer(
				child: ListView(
					padding: EdgeInsets.zero,
					children: [
						DrawerHeader(
							decoration: BoxDecoration(
								color: Colors.blue.shade700,
							),
							child: const Text(
								'Menu',
								style: TextStyle(
									color: Colors.white,
									fontSize: 24,
									fontWeight: FontWeight.bold,
								),
							),
						),
						ListTile(
							leading: const Icon(Icons.settings),
							title: const Text('Configure'),
							onTap: () async {
								Navigator.pop(context);
								await Navigator.push(
									context,
									MaterialPageRoute(
										builder: (context) => const AddHabitScreen(),
									),
								);
								habitProvider.loadHabits();
							},
						),
						ListTile(
							leading: const Icon(Icons.person),
							title: const Text('Personal Info'),
							onTap: () async {
								Navigator.pop(context);
								await Navigator.push(
									context,
									MaterialPageRoute(
											builder: (context) => const PersonalInfoScreen()),
								);
								habitProvider.loadHabits();
							},
						),
						ListTile(
							leading: const Icon(Icons.analytics),
							title: const Text('Reports'),
							onTap: () {
								Navigator.pop(context);
								Navigator.push(
									context,
									MaterialPageRoute(
											builder: (context) => const ReportsScreen()),
								);
							},
						),
						ListTile(
							leading: const Icon(Icons.notifications),
							title: const Text('Notifications'),
							onTap: () {
								Navigator.pop(context);
								Navigator.push(
									context,
									MaterialPageRoute(
											builder: (context) => const NotificationsScreen()),
								);
							},
						),
						ListTile(
							leading: const Icon(Icons.logout),
							title: const Text('Sign Out'),
							onTap: () async {
								Navigator.pushReplacement(
									context,
									MaterialPageRoute(builder: (context) => const LoginScreen()),
								);
							},
						),
					],
				),
			),
			body: habitProvider.isLoading
					? const Center(child: CircularProgressIndicator())
					: Column(
							children: [
								const Padding(
									padding: EdgeInsets.all(8.0),
									child: Text(
										'To Do 📝',
										style: TextStyle(
											fontSize: 18,
											fontWeight: FontWeight.bold,
										),
									),
								),
								selectedHabits.isEmpty
										? const Expanded(
												child: Center(
													child: Text(
														'Use the + button to create some habits!',
														style: TextStyle(fontSize: 18, color: Colors.grey),
													),
												),
											)
										: Expanded(
												child: ListView.builder(
													padding: const EdgeInsets.all(16.0),
													itemCount: selectedHabits.length,
													itemBuilder: (context, index) {
														final habit = selectedHabits[index];
														final habitColor = _getColorFromHex(habit.colorHex);
														return Dismissible(
															key: Key(habit.name),
															direction: DismissDirection.endToStart,
															onDismissed: (direction) async {
																await habitProvider.completeHabit(habit.name);
															},
															background: Container(
																color: Colors.green,
																alignment: Alignment.centerRight,
																padding: const EdgeInsets.symmetric(horizontal: 20),
																child: const Row(
																	mainAxisAlignment: MainAxisAlignment.end,
																	children: [
																		Text(
																			'Swipe to Complete',
																			style: TextStyle(color: Colors.white),
																		),
																		SizedBox(width: 10),
																		Icon(Icons.check, color: Colors.white),
																	],
																),
															),
															child: _buildHabitCard(habit.name, habitColor),
														);
													},
												),
											),
								const Divider(),
								const Padding(
									padding: EdgeInsets.all(8.0),
									child: Text(
										'Done ✅🎉',
										style: TextStyle(
											fontSize: 18,
											fontWeight: FontWeight.bold,
										),
									),
								),
								completedHabits.isEmpty
										? const Padding(
												padding: EdgeInsets.all(16.0),
												child: Text(
													'Swipe right on an activity to mark as done.',
													style: TextStyle(fontSize: 16, color: Colors.grey),
												),
											)
										: Expanded(
												child: ListView.builder(
													padding: const EdgeInsets.all(16.0),
													itemCount: completedHabits.length,
													itemBuilder: (context, index) {
														final habit = completedHabits[index];
														final habitColor = _getColorFromHex(habit.colorHex);
														return Dismissible(
															key: Key(habit.name),
															direction: DismissDirection.startToEnd,
															onDismissed: (direction) async {
																// Undo completion
																await habitProvider.deleteHabit(habit.name);
																await habitProvider.addHabit(habit.copyWith(completed: false));
															},
															background: Container(
																color: Colors.red,
																alignment: Alignment.centerLeft,
																padding: const EdgeInsets.symmetric(horizontal: 20),
																child: const Row(
																	children: [
																		Icon(Icons.undo, color: Colors.white),
																		SizedBox(width: 10),
																		Text(
																			'Swipe to Undo',
																			style: TextStyle(color: Colors.white),
																		),
																	],
																),
															),
															child: _buildHabitCard(habit.name, habitColor, isCompleted: true),
														);
													},
												),
											),
							],
						),
			floatingActionButton: selectedHabits.isEmpty
					? FloatingActionButton(
							onPressed: () {
								Navigator.push(
									context,
									MaterialPageRoute(
										builder: (context) => const AddHabitScreen(),
									),
								).then((_) => habitProvider.loadHabits());
							},
							backgroundColor: Colors.blue.shade700,
							tooltip: 'Add Habits',
							child: const Icon(Icons.add),
						)
					: null,
		);
	}

	Color _getColorFromHex(String hexColor) {
		hexColor = hexColor.replaceAll('#', '');
		if (hexColor.length == 6) {
			hexColor = 'FF$hexColor';
		}
		return Color(int.parse('0x$hexColor'));
	}

	Widget _buildHabitCard(String title, Color color, {bool isCompleted = false}) {
		return Card(
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
			color: color,
			child: SizedBox(
				height: 60,
				child: ListTile(
					title: Text(
						title.toUpperCase(),
						style: const TextStyle(
							color: Colors.white,
							fontWeight: FontWeight.bold,
							fontSize: 16,
						),
					),
					trailing: isCompleted
							? const Icon(Icons.check_circle, color: Colors.green, size: 28)
							: null,
				),
			),
		);
	}
}