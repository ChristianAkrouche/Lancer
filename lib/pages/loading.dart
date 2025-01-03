import 'package:flutter/material.dart';

class loading extends StatefulWidget {
  const loading({super.key});

  @override
  State<loading> createState() => _loadingState();
}

class _loadingState extends State<loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Image(image: AssetImage('assets/lancer-nobackground.png')),
        ]

      )

    );
  }
}
