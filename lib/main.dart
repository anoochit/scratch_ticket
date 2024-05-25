// Suggested code may be subject to a license. Learn more: ~LicenseLog:3066121167.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2706768098.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:991234137.
// Import necessary libraries
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:scratch_ticket/pages/home.dart';

void main() {
  // Ensure that all widgets are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app
  runApp(const MyApp());

  // Check if the platform is Windows, Linux, or macOS
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Wait until the window is ready
    doWhenWindowReady(() {
      // Set the initial size of the window
      const initialSize = Size(450, 750);
      appWindow.maxSize = initialSize;
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;

      // Show the window
      appWindow.show();
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,

      // Set the title of the app
      title: 'Flutter Demo',

      // Set the light theme
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),

      // Set the dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),

      // Set the theme mode to system
      themeMode: ThemeMode.system,

      // Set the home page of the app
      home: const HomePage(),
    );
  }
}
