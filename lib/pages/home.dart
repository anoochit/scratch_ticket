import 'dart:async';
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
  int _total = 12;
  int _cols = 3;

  final List<String> _icons = [
    'assets/google.png',
    'assets/flutter.png',
    'assets/dart.png'
  ];

  static const _iconJoker = 'assets/joker.png';

  final List<String> _table = [];

  String _mode = '3x4';
  int _complete = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  // Start the game by initializing the scratch keys
  void startGame() {
    _complete = 0;

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
    _complete = 0;

    // Reset table
    buildTable();

    // Rebuild the scratchers to reset their state
    List.generate(
      _total,
      (index) => _scratchKeys[index].currentState!.reset(
            duration: const Duration(milliseconds: 5),
          ),
    );
  }

  setTable({required String size}) {
    _mode = size;
    _cols = int.parse(size.split('x').first);
    _total = int.parse(size.split('x').first) * int.parse(size.split('x').last);

    setState(() {
      startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scratch!'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        actions: popupMenuItems(context),
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _cols,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemBuilder: (context, index) {
                  return scratchItem(index, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> popupMenuItems(BuildContext context) {
    return [
      TextButton(
        onPressed: () {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
                MediaQuery.sizeOf(context).width, kToolbarHeight - 24, 0, 0),
            items: [
              PopupMenuItem<String>(
                value: '2x2',
                onTap: () => setTable(size: '2x2'),
                child: const Text('2x2'),
              ),
              PopupMenuItem<String>(
                value: '3x4',
                onTap: () => setTable(size: '3x4'),
                child: const Text('3x4'),
              ),
              PopupMenuItem<String>(
                value: '4x5',
                onTap: () => setTable(size: '4x5'),
                child: const Text('4x5'),
              )
            ],
            initialValue: _mode,
          );
        },
        child: Text(_mode),
      ),
    ];
  }

  ClipRRect scratchItem(int index, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Scratcher(
        key: _scratchKeys[index],
        brushSize: 50,
        threshold: 50,
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
          onThreshold(index, context);
        },
      ),
    );
  }

  void onThreshold(int index, BuildContext context) {
    _scratchKeys[index].currentState!.reveal(
          duration: const Duration(
            milliseconds: 100,
          ),
        );

    if (_table[index].contains('joker')) {
      dev.log('Hahaha!!!');

      showHahahaDialog(context);
    } else {
      _complete++;

      if (_complete == _total) {
        showWowDialog(context);
      }
    }
  }

  Future<dynamic> showHahahaDialog(BuildContext context) {
    return showDialog(
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

  Future<dynamic> showWowDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Wow!'),
          content: const Text('You WIN!'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                setState(() {
                  resetGame();
                  Navigator.pop(context);
                });
              },
              child: Text('Reset'),
            )
          ],
        );
      },
    );
  }
}
