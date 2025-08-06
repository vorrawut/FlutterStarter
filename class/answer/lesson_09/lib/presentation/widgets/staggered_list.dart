/// Staggered list animations for coordinated reveals
/// 
/// This file provides staggered animation components for lists,
/// grids, and other collections with coordinated timing and effects.
library;

import 'package:flutter/material.dart';
import '../../core/animations/animation_mixins.dart';
import '../../core/animations/custom_curves.dart';
import '../../core/constants/animation_constants.dart';
import '../../domain/entities/onboarding_page.dart';

/// Staggered feature list for onboarding pages
/// 
/// Displays a list of features with staggered entrance animations
/// that create a coordinated, professional reveal sequence.
class StaggeredFeatureList extends StatefulWidget {
  /// Creates a staggered feature list
  const StaggeredFeatureList({
    super.key,
    required this.features,
    this.staggerDelay = AnimationConstants.staggerDelay,
    this.animationDuration = AnimationConstants.standardDuration,
    this.curve = AnimationCurves.gentleSpring,
    this.slideDistance = 30.0,
    this.autoStart = true,
  });

  /// List of features to display
  final List<OnboardingFeature> features;

  /// Delay between each item animation
  final Duration staggerDelay;

  /// Duration for each item animation
  final Duration animationDuration;

  /// Animation curve
  final Curve curve;

  /// Distance to slide from
  final double slideDistance;

  /// Whether to start animations automatically
  final bool autoStart;

  @override
  State<StaggeredFeatureList> createState() => _StaggeredFeatureListState();
}

class _StaggeredFeatureListState extends State<StaggeredFeatureList>
    with TickerProviderStateMixin {

  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _fadeAnimations = [];
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _scaleAnimations = [];

  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        startAnimations();
      });
    }
  }

  /// Initialize animations for all feature items
  void _initializeAnimations() {
    for (int i = 0; i < widget.features.length; i++) {
      final controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ));

      final slideAnimation = Tween<Offset>(
        begin: Offset(0.0, widget.slideDistance / 100),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.2, 1.0, curve: widget.curve),
      ));

      final scaleAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.4, 1.0, curve: AnimationCurves.gentleSpring),
      ));

      _controllers.add(controller);
      _fadeAnimations.add(fadeAnimation);
      _slideAnimations.add(slideAnimation);
      _scaleAnimations.add(scaleAnimation);
    }
  }

  /// Start staggered animations
  Future<void> startAnimations() async {
    if (_hasStarted) return;
    _hasStarted = true;

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.staggerDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  /// Reverse animations
  Future<void> reverseAnimations() async {
    for (int i = _controllers.length - 1; i >= 0; i--) {
      Future.delayed(widget.staggerDelay * (_controllers.length - 1 - i), () {
        if (mounted) {
          _controllers[i].reverse();
        }
      });
    }
    _hasStarted = false;
  }

  /// Reset animations
  void resetAnimations() {
    for (final controller in _controllers) {
      controller.reset();
    }
    _hasStarted = false;
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        return _buildFeatureItem(feature, index);
      }).toList(),
    );
  }

  /// Build individual feature item with animations
  Widget _buildFeatureItem(OnboardingFeature feature, int index) {
    if (index >= _controllers.length) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _fadeAnimations[index],
        _slideAnimations[index],
        _scaleAnimations[index],
      ]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: Transform.scale(
              scale: _scaleAnimations[index].value,
              child: child,
            ),
          ),
        );
      },
      child: _buildFeatureCard(feature),
    );
  }

  /// Build feature card widget
  Widget _buildFeatureCard(OnboardingFeature feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Feature icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (feature.color ?? Theme.of(context).colorScheme.primary)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature.icon,
              color: feature.color ?? Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Feature content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Staggered grid for general use
/// 
/// A flexible staggered grid that can display any widgets
/// with coordinated entrance animations.
class StaggeredGrid extends StatefulWidget {
  /// Creates a staggered grid
  const StaggeredGrid({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 16.0,
    this.crossAxisSpacing = 16.0,
    this.childAspectRatio = 1.0,
    this.staggerDelay = AnimationConstants.staggerDelay,
    this.animationDuration = AnimationConstants.standardDuration,
    this.curve = AnimationCurves.gentleSpring,
    this.autoStart = true,
  });

  /// Grid children
  final List<Widget> children;

  /// Number of columns
  final int crossAxisCount;

  /// Spacing between rows
  final double mainAxisSpacing;

  /// Spacing between columns
  final double crossAxisSpacing;

  /// Aspect ratio of children
  final double childAspectRatio;

  /// Delay between each item animation
  final Duration staggerDelay;

  /// Duration for each item animation
  final Duration animationDuration;

  /// Animation curve
  final Curve curve;

  /// Whether to start animations automatically
  final bool autoStart;

  @override
  State<StaggeredGrid> createState() => _StaggeredGridState();
}

class _StaggeredGridState extends State<StaggeredGrid>
    with TickerProviderStateMixin {

  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAnimations();
      });
    }
  }

  void _initializeAnimations() {
    for (int i = 0; i < widget.children.length; i++) {
      final controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ));

      _controllers.add(controller);
      _animations.add(animation);
    }
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.staggerDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return _buildAnimatedItem(index);
      },
    );
  }

  Widget _buildAnimatedItem(int index) {
    if (index >= _animations.length) {
      return widget.children[index];
    }

    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        final value = _animations[index].value;
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          ),
        );
      },
      child: widget.children[index],
    );
  }
}

/// Staggered text reveal
/// 
/// Animates text characters or words with staggered timing
/// for dramatic text reveals.
class StaggeredTextReveal extends StatefulWidget {
  /// Creates a staggered text reveal
  const StaggeredTextReveal({
    super.key,
    required this.text,
    this.style,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.animationDuration = AnimationConstants.standardDuration,
    this.curve = Curves.easeOutBack,
    this.revealMode = TextRevealMode.word,
    this.autoStart = true,
  });

  /// Text to reveal
  final String text;

  /// Text style
  final TextStyle? style;

  /// Delay between each character/word
  final Duration staggerDelay;

  /// Duration for each character/word animation
  final Duration animationDuration;

  /// Animation curve
  final Curve curve;

  /// Whether to reveal by character or word
  final TextRevealMode revealMode;

  /// Whether to start animations automatically
  final bool autoStart;

  @override
  State<StaggeredTextReveal> createState() => _StaggeredTextRevealState();
}

class _StaggeredTextRevealState extends State<StaggeredTextReveal>
    with TickerProviderStateMixin {

  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];
  List<String> _textParts = [];

  @override
  void initState() {
    super.initState();
    _splitText();
    _initializeAnimations();
    
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAnimations();
      });
    }
  }

  void _splitText() {
    switch (widget.revealMode) {
      case TextRevealMode.character:
        _textParts = widget.text.split('');
        break;
      case TextRevealMode.word:
        _textParts = widget.text.split(' ');
        break;
    }
  }

  void _initializeAnimations() {
    for (int i = 0; i < _textParts.length; i++) {
      final controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ));

      _controllers.add(controller);
      _animations.add(animation);
    }
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.staggerDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _textParts.asMap().entries.map((entry) {
        final index = entry.key;
        final part = entry.value;
        return _buildAnimatedTextPart(part, index);
      }).toList(),
    );
  }

  Widget _buildAnimatedTextPart(String part, int index) {
    if (index >= _animations.length) {
      return Text(part, style: widget.style);
    }

    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        final value = _animations[index].value;
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 10 * (1 - value)),
              child: child,
            ),
          ),
        );
      },
      child: Text(
        widget.revealMode == TextRevealMode.word ? '$part ' : part,
        style: widget.style,
      ),
    );
  }
}

/// Text reveal mode enumeration
enum TextRevealMode {
  /// Reveal character by character
  character,

  /// Reveal word by word
  word,
}