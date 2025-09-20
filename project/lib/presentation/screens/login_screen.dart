import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



import 'package:ibm_habit_tracker/presentation/screens/register_screen.dart';
import 'habit_tracker_screen.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
	const LoginScreen({super.key});

	@override
	_LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
	final _usernameController = TextEditingController();
	final _passwordController = TextEditingController();

		void _login() async {
			final username = _usernameController.text;
			final password = _passwordController.text;
			final authProvider = Provider.of<AuthProvider>(context, listen: false);
			await authProvider.login(username, password);
			if (authProvider.user != null) {
				Navigator.pushReplacement(
					context,
					MaterialPageRoute(
						builder: (context) => HabitTrackerScreen(username: authProvider.user!.username),
					),
				);
			} else if (authProvider.error != null) {
				Fluttertoast.showToast(
					msg: authProvider.error!,
					toastLength: Toast.LENGTH_SHORT,
					gravity: ToastGravity.BOTTOM,
					backgroundColor: Colors.red,
					textColor: Colors.white,
					fontSize: 16.0,
				);
			}
		}

	@override
	Widget build(BuildContext context) {
			return Scaffold(
				body: Consumer<AuthProvider>(
					builder: (context, authProvider, _) {
						return Container(
							decoration: BoxDecoration(
								gradient: LinearGradient(
									colors: [Colors.blue.shade700, Colors.blue.shade900],
									begin: Alignment.topCenter,
									end: Alignment.bottomCenter,
								),
							),
							child: Center(
								child: SingleChildScrollView(
									padding: const EdgeInsets.all(24.0),
									child: Column(
										mainAxisAlignment: MainAxisAlignment.center,
										children: [
											const Text(
												'Habitt',
												style: TextStyle(
													fontSize: 32,
													fontWeight: FontWeight.bold,
													color: Colors.white,
												),
											),
											const SizedBox(height: 30),
											Container(
												decoration: BoxDecoration(
													color: Colors.white,
													borderRadius: BorderRadius.circular(30),
												),
												child: TextField(
													controller: _usernameController,
													decoration: InputDecoration(
														prefixIcon:
																Icon(Icons.email, color: Colors.blue.shade700),
														hintText: 'Enter Username',
														border: InputBorder.none,
														contentPadding: const EdgeInsets.symmetric(
																horizontal: 20, vertical: 15),
													),
												),
											),
											const SizedBox(height: 20),
											Container(
												decoration: BoxDecoration(
													color: Colors.white,
													borderRadius: BorderRadius.circular(30),
												),
												child: TextField(
													controller: _passwordController,
													obscureText: true,
													decoration: InputDecoration(
														prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
														hintText: 'Enter Password',
														border: InputBorder.none,
														contentPadding: const EdgeInsets.symmetric(
																horizontal: 20, vertical: 15),
													),
												),
											),
											const SizedBox(height: 20),
											Align(
												alignment: Alignment.centerRight,
												child: TextButton(
																			onPressed: () async {
																				final username = _usernameController.text;
																				if (username.isEmpty) {
																					Fluttertoast.showToast(
																						msg: 'Enter your username to reset password',
																						toastLength: Toast.LENGTH_SHORT,
																						gravity: ToastGravity.BOTTOM,
																						backgroundColor: Colors.red,
																						textColor: Colors.white,
																						fontSize: 16.0,
																					);
																				} else {
																					await Provider.of<AuthProvider>(context, listen: false).resetPassword(username);
																					final error = Provider.of<AuthProvider>(context, listen: false).error;
																					if (error != null) {
																						Fluttertoast.showToast(
																							msg: error,
																							toastLength: Toast.LENGTH_SHORT,
																							gravity: ToastGravity.BOTTOM,
																							backgroundColor: Colors.green,
																							textColor: Colors.white,
																							fontSize: 16.0,
																						);
																					}
																				}
																			},
													child: const Text(
														'Forgot password?',
														style: TextStyle(color: Colors.white),
													),
												),
											),
											const SizedBox(height: 20),
											authProvider.loading
													? const CircularProgressIndicator(color: Colors.white)
													: ElevatedButton(
															onPressed: _login,
															style: ElevatedButton.styleFrom(
																backgroundColor: Colors.blue.shade600,
																shape: RoundedRectangleBorder(
																	borderRadius: BorderRadius.circular(30.0),
																),
																padding: const EdgeInsets.symmetric(
																		horizontal: 80, vertical: 15),
															),
															child: const Text(
																'Log in',
																style: TextStyle(
																	fontSize: 18,
																	color: Colors.white,
																	fontWeight: FontWeight.bold,
																),
															),
														),
											const SizedBox(height: 20),
											const Text(
												'or',
												style: TextStyle(color: Colors.white70),
											),
											const SizedBox(height: 10),
											OutlinedButton(
												onPressed: () {
													Navigator.push(
														context,
														MaterialPageRoute(
																builder: (context) => RegisterScreen()),
													);
												},
												style: OutlinedButton.styleFrom(
													side: const BorderSide(color: Colors.white),
													shape: RoundedRectangleBorder(
														borderRadius: BorderRadius.circular(30.0),
													),
													padding: const EdgeInsets.symmetric(
															horizontal: 70, vertical: 15),
												),
												child: const Text(
													'Sign up',
													style: TextStyle(color: Colors.white, fontSize: 16),
												),
											),
										],
									),
								),
							),
						);
					},
				),
			);
	}
}