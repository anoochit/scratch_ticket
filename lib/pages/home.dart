// Suggested code may be subject to a license. Learn more: ~LicenseLog:3113354304.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1913141808.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3817003600.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3355681459.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1433212669.
// Import necessary libraries
import 'dart:math';
import 'dart:developer' as dev;

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

  final List<String> _icons = [
    'assets/google.png',
    'assets/flutter.png',
    'assets/dart.png'
  ];

  static const _iconJoker = 'assets/joker.png';

  final List<String> _table = [];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  // Start the game by initializing the scratch keys
  void startGame() {
    buildTable();

    // Clear the existing scratch keys
    _scratchKeys.clear();

    // Generate a new list of scratch keys
    List.generate(
      _total,
      (index) => _scratchKeys.add(GlobalKey<ScratcherState>()),
    );
  }

  buildTable() {
    final iconIndex = Random().nextInt(3);
    _table.clear();
    for (int i = 0; i < _total; i++) {
      if (randomJoker()) {
        _table.add(_icons[iconIndex]);
      } else {
        _table.add(_iconJoker);
      }
    }
  }

  bool randomJoker() {
    return Random().nextBool();
  }

  // Reset the game by resetting all scratchers and setting the completed count to 0
  void resetGame() {
    // Reset the completed count

    buildTable();

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
        title: const Text('Scratch!'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
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
                      key: _scratchKeys[index],
                      brushSize: 30,
                      threshold: 30,
                      color: Theme.of(context).colorScheme.primary,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Container(
                          height: constraints.maxWidth,
                          width: constraints.maxWidth,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(_table[index]),
                          ),
                        );
                      }),
                      onThreshold: () {
                        _scratchKeys[index].currentState!.reveal(
                            duration: const Duration(milliseconds: 100));

                        if (_table[index].contains('joker')) {
                          dev.log('Hahaha!!!');

                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Hahahaha'),
                                content: const Text('You lose!'),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  FilledButton(
                                    onPressed: () {
                                      setState(() {
                                        resetGame();
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: const Text('Reset'),
                                  )
                                ],
                              );
                            },
                          );
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
    );
  }
}
