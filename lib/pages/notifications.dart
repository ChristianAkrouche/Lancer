import 'package:flutter/material.dart';
import '../Components/Drawer Components/drawer.dart';

class notifications extends StatelessWidget {
  const notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const drawer(),
    );
  }
}
