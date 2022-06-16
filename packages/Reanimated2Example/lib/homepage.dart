import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double maxWidth = 0;
  double containerWidth = 100;

  void updateContainerWidth() {
    var random = math.Random();

    setState(() {
      containerWidth = random.nextDouble() * maxWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              height: MediaQuery.of(context).size.height * 0.1,
              width: containerWidth,
              duration: const Duration(milliseconds: 500),
              color: Colors.black,
              curve: Curves.easeIn,
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: ElevatedButton(
                onPressed: updateContainerWidth,
                child: const Text('Toggle'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
