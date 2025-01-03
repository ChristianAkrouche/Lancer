import 'package:flutter/material.dart';
import '../Components/Drawer Components/drawer.dart';

class messages extends StatelessWidget {
  const messages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: drawer(),
    );
  }
}
