import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scratchKeys = <GlobalKey<ScratcherState>>[];

  final int _total = 12;
  int _complete = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  // start game
  startGame() {
    // clear scratch key
    _scratchKeys.clear();

    // get scratch key
    List.generate(
      _total,
      (index) => _scratchKeys.add(GlobalKey<ScratcherState>()),
    );
  }

  // reset game
  resetGame() {
    // complete
    _complete = 0;
    // rebuild
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
                // random
                resetGame();
              },
               icon: const Icon(Icons.refresh),
            )
        ],
      ),
      body: Center(
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
                  borderRadius: BorderRadius.circular(12.0),
                  child: Scratcher(
                    key: _scratchKeys[index],
                    brushSize: 30,
                    threshold: 80,
                    color: Theme.of(context).colorScheme.primary,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Container(
                        height: constraints.maxWidth,
                        width: constraints.maxWidth,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/flutter.png'),
                        ),
                      );
                    }),
                    onThreshold: () {
                      _complete++;

                      if (_complete == _total) {
                        // check result
                        // show result dialog
                      }
                    },
                  ),
                );
              },
            ),
           
          ],
        ),
      ),
    );
  }
}
