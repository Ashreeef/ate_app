import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../utils/constants.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _dropAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _expansionAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
    // Trigger auth check on splash screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const AuthCheckRequested());
    });
  }

  void _initializeAnimations() {
    // Main controller for entire sequence (3 seconds)
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // 1. Drop animation: 0ms -> 600ms
    // Start from above screen to center
    _dropAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    // 2. Bounce on landing: 600ms -> 750ms
    // Vertical bounce effect (moves up then down)
    _bounceAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.0,
              end: -20.0,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: -20.0,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.bounceOut)),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.2, 0.25, curve: Curves.linear),
          ),
        );

    // 3. Scale animation with multiple growth phases: 750ms -> 1700ms
    _scaleAnimation =
        TweenSequence<double>([
          // Wait for bounce to finish
          TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 5),
          // First growth: 1.0 -> 2.2 with overshoot (750ms -> 1150ms)
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.0,
              end: 2.2,
            ).chain(CurveTween(curve: Curves.elasticOut)),
            weight: 35,
          ),
          // Pause at 2.2 (1150ms -> 1300ms)
          TweenSequenceItem(tween: ConstantTween<double>(2.2), weight: 15),
          // Second growth: 2.2 -> 4.0 with overshoot (1300ms -> 1700ms)
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 2.2,
              end: 4.0,
            ).chain(CurveTween(curve: Curves.elasticOut)),
            weight: 45,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.2, 0.567, curve: Curves.linear),
          ),
        );

    // 4. Final expansion to fill screen: 1700ms -> 2200ms
    _expansionAnimation = Tween<double>(begin: 1.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.567, 0.733, curve: Curves.easeInOut),
      ),
    );

    // 5. Background color transition during expansion
    _backgroundColorAnimation =
        ColorTween(begin: AppColors.white, end: AppColors.primary).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.567, 0.733, curve: Curves.easeInOut),
          ),
        );

    // 6. Logo fade in: starts immediately when expansion completes at 2200ms
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.583333, 0.65, curve: Curves.easeIn),
      ),
    );
  }

  void _startAnimationSequence() async {
    // Start the animation
    await _mainController.forward();

    // Hold logo for a moment
    await Future.delayed(const Duration(milliseconds: 400));

    // Navigate to next screen
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    if (mounted) {
      // Check authentication status from AuthBloc
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        // User is logged in, go directly to home
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // User not logged in, show onboarding
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final circleSize = AppSizes.dotLg; // currently 32.0

    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        // Calculate drop position (from top to center)
        final dropOffset = _dropAnimation.value * size.height;

        // Calculate bounce offset (after landing)
        final bounceOffset =
            _mainController.value >= 0.2 && _mainController.value <= 0.25
            ? _bounceAnimation.value
            : 0.0;

        // Calculate scale (growth phases + expansion)
        final baseScale = _scaleAnimation.value;
        final expansionMultiplier = _mainController.value >= 0.567
            ? _expansionAnimation.value
            : 1.0;
        final finalScale = baseScale * expansionMultiplier;

        // Get background color
        final bgColor = _backgroundColorAnimation.value ?? AppColors.white;

        // Calculate circle position
        final circleY = centerY + dropOffset + bounceOffset;
        final circleX = centerX;

        // Calculate final circle size
        final finalCircleSize = circleSize * finalScale;

        return Scaffold(
          backgroundColor: bgColor,
          body: Stack(
            children: [
              // Animated red circle
              Positioned(
                left: circleX - finalCircleSize / 2,
                top: circleY - finalCircleSize / 2,
                child: Container(
                  width: finalCircleSize,
                  height: finalCircleSize,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Logo (fades in after expansion)
              if (_logoFadeAnimation.value > 0)
                Center(
                  child: Opacity(
                    opacity: _logoFadeAnimation.value,
                    child: SvgPicture.asset(
                      'assets/images/logo_white.svg',
                      width: 150,
                      height: 110,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
