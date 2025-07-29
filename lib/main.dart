import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/screens/home_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:recipe_app/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Method to check if the user is logged in
  Future<Widget> _getInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(
      'email',
    ); // Check if email exists in SharedPreferences

    if (email != null) {
      // If email exists, user is logged in
      return HomePage(); // Navigate to HomePage
    } else {
      // If email doesn't exist, user is not logged in
      return LoginPage(); // Navigate to LoginPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        // Show a loading screen until the session check is completed
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        // Once the session check is complete, navigate to the appropriate screen
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home:
              snapshot.data ?? LoginPage(), // Navigate to the determined screen
        );
      },
    );
  }
}
