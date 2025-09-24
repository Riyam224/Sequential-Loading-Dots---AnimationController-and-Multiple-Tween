import 'package:flutter/material.dart';
import 'package:sequential_loading_dots/home_view.dart';

void main() {
  runApp(const SequentialLoadingDots());
}

class SequentialLoadingDots extends StatelessWidget {
  const SequentialLoadingDots({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeView());
  }
}
