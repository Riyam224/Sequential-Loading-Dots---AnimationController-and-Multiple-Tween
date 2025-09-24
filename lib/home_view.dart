import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    // Scale: 
    _scaleAnimations = List.generate(3, (i) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.0,
            end: 1.2,
          ).chain(CurveTween(curve: Curves.easeOutCubic)), // fast grow
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.2,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeOut)), // settle back
          weight: 15,
        ),
        TweenSequenceItem(
          tween: ConstantTween<double>(1.0), // hold steady
          weight: 60,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i * 0.25, // stagger each dot
            (i * 0.25 + 0.8).clamp(0.0, 1.0),
            curve: Curves.linear,
          ),
        ),
      );
    });

    // Opacity: fade in and hold
    _opacityAnimations = List.generate(3, (i) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 40,
        ),
        TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 60),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i * 0.25,
            (i * 0.25 + 0.8).clamp(0.0, 1.0),
            curve: Curves.linear,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return ScaleTransition(
      scale: _scaleAnimations[index],
      child: FadeTransition(
        opacity: _opacityAnimations[index],
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5FF),
      appBar: AppBar(
        title: const Text('Sequential Loading Dots'),
        leading: const Icon(Icons.arrow_back_ios),
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [_buildDot(0), _buildDot(1), _buildDot(2)],
        ),
      ),
    );
  }
}
