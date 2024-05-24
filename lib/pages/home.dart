import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8.0),
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
            itemBuilder: (context, index) {
              return Scratcher(
                brushSize: 50,
                threshold: 80,
                color: Colors.red,
                image: Image.asset('assets/scratch.png'),
                child: Container(
                  height: 300,
                  width: 300,
                  color: Colors.grey[100],
                  child: Image.asset('assets/flutter.png'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
