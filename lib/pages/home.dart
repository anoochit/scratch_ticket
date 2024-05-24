import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scratchKeys = <GlobalKey<ScratcherState>>[];

  int total = 9;
  int complete = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startGame();
  }

  // start game
  startGame() {
    // clear scratch key
    scratchKeys.clear();

    // get scratch key
    List.generate(
      total,
      (index) => scratchKeys.add(GlobalKey<ScratcherState>()),
    );
  }

  // reset game
  resetGame() {
    // complete
    complete = 0;
    // rebuild
    List.generate(
      total,
      (index) => scratchKeys[index].currentState!.reset(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              itemCount: total,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Scratcher(
                    key: scratchKeys[index],
                    brushSize: 50,
                    threshold: 60,
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
                      complete++;

                      if (complete == total) {
                        // check result
                        // show result dialog
                      }
                    },
                  ),
                );
              },
            ),
            FilledButton.icon(
              onPressed: () {
                // random
                resetGame();
              },
              label: const Text('Refresh'),
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
      ),
    );
  }
}
