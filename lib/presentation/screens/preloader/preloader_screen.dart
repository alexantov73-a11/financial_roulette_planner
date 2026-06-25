import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/preloader_viewmodel.dart';

class PreloaderScreen extends StatefulWidget {
  const PreloaderScreen({super.key});

  @override
  State<PreloaderScreen> createState() => _PreloaderScreenState();
}

class _PreloaderScreenState extends State<PreloaderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    final route = await context.read<PreloaderViewModel>().initializeApp();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RotationTransition(
          turns: _controller,
          child: Icon(
            Icons.trending_up,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
