/// Animated page view with custom transitions
/// 
/// This file provides an enhanced PageView with sophisticated transition
/// animations, physics-based motion, and coordinated element animations.
library;

import 'package:flutter/material.dart';
import '../../core/animations/animation_mixins.dart';
import '../../core/animations/custom_curves.dart';
import '../../core/constants/animation_constants.dart';

/// Animated page view with enhanced transitions
/// 
/// Provides smooth page transitions with custom animations,
/// parallax effects, and coordinated element reveals.
class AnimatedPageView extends StatefulWidget {
  /// Creates an animated page view
  const AnimatedPageView({
    super.key,
    required this.children,
    this.controller,
    this.onPageChanged,
    this.physics,
    this.enableParallax = true,
    this.parallaxStrength = 0.3,
    this.transitionDuration = AnimationConstants.standardDuration,
    this.transitionCurve = AnimationCurves.gentleSpring,
  });

  /// Page widgets
  final List<Widget> children;

  /// Page controller
  final PageController? controller;

  /// Page change callback
  final void Function(int)? onPageChanged;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Whether to enable parallax effects
  final bool enableParallax;

  /// Strength of parallax effect (0.0 to 1.0)
  final double parallaxStrength;

  /// Transition animation duration
  final Duration transitionDuration;

  /// Transition animation curve
  final Curve transitionCurve;

  @override
  State<AnimatedPageView> createState() => _AnimatedPageViewState();
}

class _AnimatedPageViewState extends State<AnimatedPageView>
    with TickerProviderStateMixin {
  
  late PageController _pageController;
  double _currentPage = 0.0;
  int _lastReportedPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = widget.controller ?? PageController();
    _pageController.addListener(_onPageControllerChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _pageController.dispose();
    } else {
      _pageController.removeListener(_onPageControllerChanged);
    }
    super.dispose();
  }

  void _onPageControllerChanged() {
    if (_pageController.hasClients) {
      final newPage = _pageController.page ?? 0.0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });

        // Report page changes at integer boundaries
        final roundedPage = newPage.round();
        if (roundedPage != _lastReportedPage) {
          _lastReportedPage = roundedPage;
          widget.onPageChanged?.call(roundedPage);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      physics: widget.physics,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return _buildAnimatedPage(index);
      },
    );
  }

  /// Build animated page with transitions
  Widget _buildAnimatedPage(int index) {
    // Calculate page offset for animations
    final offset = _currentPage - index;
    final absOffset = offset.abs();

    // Apply page transition transformations
    return Transform(
      alignment: Alignment.center,
      transform: _getPageTransform(offset),
      child: Opacity(
        opacity: _getPageOpacity(absOffset),
        child: widget.enableParallax
            ? _buildParallaxPage(widget.children[index], offset)
            : widget.children[index],
      ),
    );
  }

  /// Get transformation matrix for page transition
  Matrix4 _getPageTransform(double offset) {
    final matrix = Matrix4.identity();
    final absOffset = offset.abs();

    if (absOffset <= 1.0) {
      // Scale effect during transition
      final scale = 1.0 - (absOffset * 0.1);
      matrix.scale(scale, scale, 1.0);

      // Slight rotation for dramatic effect
      final rotation = offset * 0.05;
      matrix.rotateZ(rotation);

      // Depth effect with perspective
      final perspective = 0.001;
      matrix.setEntry(3, 2, perspective);
      
      // Z translation for depth
      final zTranslation = absOffset * -100;
      matrix.translate(0.0, 0.0, zTranslation);
    }

    return matrix;
  }

  /// Get opacity for page transition
  double _getPageOpacity(double absOffset) {
    if (absOffset <= 1.0) {
      return 1.0 - (absOffset * 0.3);
    }
    return 0.7;
  }

  /// Build page with parallax effect
  Widget _buildParallaxPage(Widget child, double offset) {
    return Transform.translate(
      offset: Offset(offset * 50 * widget.parallaxStrength, 0),
      child: child,
    );
  }
}

/// Animated page indicator
/// 
/// Shows page position with smooth animated transitions
/// and customizable appearance.
class AnimatedPageIndicator extends StatefulWidget {
  /// Creates an animated page indicator
  const AnimatedPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
    this.activeColor,
    this.inactiveColor,
    this.size = 8.0,
    this.spacing = 8.0,
    this.animationDuration = AnimationConstants.fastDuration,
    this.animationCurve = Curves.easeInOut,
  });

  /// Total number of pages
  final int pageCount;

  /// Current page index (can be fractional for smooth transitions)
  final double currentPage;

  /// Color of active indicator
  final Color? activeColor;

  /// Color of inactive indicators
  final Color? inactiveColor;

  /// Size of indicators
  final double size;

  /// Spacing between indicators
  final double spacing;

  /// Animation duration for transitions
  final Duration animationDuration;

  /// Animation curve for transitions
  final Curve animationCurve;

  @override
  State<AnimatedPageIndicator> createState() => _AnimatedPageIndicatorState();
}

class _AnimatedPageIndicatorState extends State<AnimatedPageIndicator>
    with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  double _lastPage = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );
    _lastPage = widget.currentPage;
  }

  @override
  void didUpdateWidget(AnimatedPageIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPage != oldWidget.currentPage) {
      _lastPage = oldWidget.currentPage;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.colorScheme.primary;
    final inactiveColor = widget.inactiveColor ?? theme.colorScheme.outline;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentPage = _lerp(_lastPage, widget.currentPage, _animation.value);
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.pageCount, (index) {
            return _buildIndicator(index, currentPage, activeColor, inactiveColor);
          }),
        );
      },
    );
  }

  /// Build individual page indicator
  Widget _buildIndicator(int index, double currentPage, Color activeColor, Color inactiveColor) {
    final distance = (currentPage - index).abs();
    final isActive = distance < 0.5;
    final opacity = isActive ? 1.0 : (1.0 - distance).clamp(0.3, 1.0);
    final scale = isActive ? 1.0 : 0.8;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: widget.animationCurve,
        width: widget.size * scale,
        height: widget.size * scale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.lerp(inactiveColor, activeColor, opacity),
        ),
      ),
    );
  }

  /// Linear interpolation helper
  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

/// Page transition animations
/// 
/// Collection of custom page transition animations for enhanced
/// navigation experiences.
class PageTransitions {
  /// Private constructor
  const PageTransitions._();

  /// Fade transition
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Slide transition
  static Widget slideTransition({
    required Widget child,
    required Animation<double> animation,
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
  }) {
    final offsetAnimation = Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(animation);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  /// Scale transition
  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
    double begin = 0.0,
    double end = 1.0,
  }) {
    final scaleAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(animation);

    return ScaleTransition(
      scale: scaleAnimation,
      child: child,
    );
  }

  /// Rotation transition
  static Widget rotationTransition({
    required Widget child,
    required Animation<double> animation,
    double begin = 0.0,
    double end = 1.0,
  }) {
    final rotationAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(animation);

    return RotationTransition(
      turns: rotationAnimation,
      child: child,
    );
  }

  /// Combined slide and fade transition
  static Widget slideAndFadeTransition({
    required Widget child,
    required Animation<double> animation,
    Offset slideBegin = const Offset(1.0, 0.0),
    Offset slideEnd = Offset.zero,
    double fadeBegin = 0.0,
    double fadeEnd = 1.0,
  }) {
    final slideAnimation = Tween<Offset>(
      begin: slideBegin,
      end: slideEnd,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    final fadeAnimation = Tween<double>(
      begin: fadeBegin,
      end: fadeEnd,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }

  /// Combined scale and fade transition
  static Widget scaleAndFadeTransition({
    required Widget child,
    required Animation<double> animation,
    double scaleBegin = 0.8,
    double scaleEnd = 1.0,
    double fadeBegin = 0.0,
    double fadeEnd = 1.0,
  }) {
    final scaleAnimation = Tween<double>(
      begin: scaleBegin,
      end: scaleEnd,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.8, curve: AnimationCurves.gentleSpring),
    ));

    final fadeAnimation = Tween<double>(
      begin: fadeBegin,
      end: fadeEnd,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }

  /// Hero-style transition with scaling and morphing
  static Widget heroTransition({
    required Widget child,
    required Animation<double> animation,
    double scaleBegin = 0.5,
    double scaleEnd = 1.0,
  }) {
    final scaleAnimation = Tween<double>(
      begin: scaleBegin,
      end: scaleEnd,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: AnimationCurves.dramaticElastic,
    ));

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }
}