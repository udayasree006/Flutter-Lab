import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AnimationPage(),
    );
  }
}

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  bool rotate = false;
  bool scale = false;
  bool fade = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Widget Animations"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ROTATE
            GestureDetector(
              onTap: () {
                setState(() {
                  rotate = !rotate;
                });
              },
              child: AnimatedRotation(
                turns: rotate ? 0.25 : 0,
                duration: const Duration(milliseconds: 400),
                child: Container(
                  width: 120,
                  height: 80,
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      "ROTATE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // SCALE
            GestureDetector(
              onTap: () {
                setState(() {
                  scale = !scale;
                });
              },
              child: AnimatedScale(
                scale: scale ? 1.4 : 1.0,
                duration: const Duration(milliseconds: 400),
                child: Container(
                  width: 120,
                  height: 80,
                  color: Colors.green,
                  child: const Center(
                    child: Text(
                      "SCALE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // FADE
            GestureDetector(
              onTap: () {
                setState(() {
                  fade = !fade;
                });
              },
              child: AnimatedOpacity(
                opacity: fade ? 0.2 : 1.0,
                duration: const Duration(milliseconds: 400),
                child: Container(
                  width: 120,
                  height: 80,
                  color: Colors.orange,
                  child: const Center(
                    child: Text(
                      "FADE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
