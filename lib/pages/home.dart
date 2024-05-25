// Suggested code may be subject to a license. Learn more: ~LicenseLog:3113354304.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1913141808.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3817003600.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3355681459.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1433212669.
// Import necessary libraries
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List of scratch keys for each scratcher widget
  final _scratchKeys = <GlobalKey<ScratcherState>>[];

  // Total number of scratchers
  final int _total = 12;

  // Number of completed scratchers
  int _complete = 0;

  int _icon_index = 0;

  final List<String> _icons = ['assets/google.png', 'assets/flutter.png', 'assets/dart.png'];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  // Start the game by initializing the scratch keys
  void startGame() {

    _icon_index = Random().nextInt(3);



    // Clear the existing scratch keys
    _scratchKeys.clear();

    // Generate a new list of scratch keys
    List.generate(
      _total,
      (index) => _scratchKeys.add(GlobalKey<ScratcherState>()),
    );
  }

  // Reset the game by resetting all scratchers and setting the completed count to 0
  void resetGame() {
    // Reset the completed count
    _complete = 0;

    _icon_index = Random().nextInt(3);

    // Rebuild the scratchers to reset their state
    List.generate(
      _total,
      (index) => _scratchKeys[index].currentState!.reset(
            duration: const Duration(milliseconds: 5),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scratch Lotto!'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        actions: [
           IconButton(
              onPressed: () {
                // Randomly reset the game
                setState(() {
                   resetGame();
                });
               
              },
               icon: const Icon(Icons.refresh),
            )
        ],
      ),
      body: Expanded(
        child: Center(
          child: SizedBox(
            width: (kIsWeb) ? 480 : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _total,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Scratcher(
                        key: _scratchKeys[index], // Use the scratch key for this scratcher
                        brushSize: 30,
                        threshold: 80,
                        // image: Image.asset('assets/scratch.png'),
                        color: Theme.of(context).colorScheme.primary,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Container(
                            height: constraints.maxWidth,
                            width: constraints.maxWidth,
                            color: Theme.of(context).colorScheme.primaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(_icons[_icon_index]),
                            ),
                          );
                        }),
                        onThreshold: () {
                          // Increment the completed count
                          _complete++;

                          _scratchKeys[index].currentState!.reveal(duration: const Duration(milliseconds: 100));
            
                          // Check if all scratchers are completed
                          if (_complete == _total) {
                            // Check the result and show a dialog
                          }
                        },
                      ),
                    );
                  },
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
