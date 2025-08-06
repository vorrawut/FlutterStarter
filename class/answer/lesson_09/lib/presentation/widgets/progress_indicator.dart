/// Animated progress indicators
/// 
/// This file provides sophisticated progress indicators with smooth animations,
/// pulse effects, and customizable appearances for onboarding flows.
library;

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/animations/custom_curves.dart';
import '../../core/constants/animation_constants.dart';

/// Animated progress indicator for onboarding
/// 
/// A sophisticated progress indicator with smooth animations,
/// customizable appearance, and delightful micro-interactions.
class AnimatedProgressIndicator extends StatefulWidget {
  /// Creates an animated progress indicator
  const AnimatedProgressIndicator({
    super.key,
    required this.progress,
    this.height = 4.0,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius = 2.0,
    this.animationDuration = AnimationConstants.standardDuration,
    this.animationCurve = AnimationCurves.gentleSpring,
    this.enablePulse = false,
    this.pulseDuration = const Duration(milliseconds: 1500),
    this.enableGlow = true,
    this.showPercentage = false,
  });

  /// Progress value (0.0 to 1.0)
  final double progress;

  /// Height of the progress bar
  final double height;

  /// Background color
  final Color? backgroundColor;

  /// Progress color
  final Color? progressColor;

  /// Border radius
  final double borderRadius;

  /// Animation duration for progress changes
  final Duration animationDuration;

  /// Animation curve
  final Curve animationCurve;

  /// Whether to enable pulse effect
  final bool enablePulse;

  /// Pulse animation duration
  final Duration pulseDuration;

  /// Whether to enable glow effect
  final bool enableGlow;

  /// Whether to show percentage text
  final bool showPercentage;

  @override
  State<AnimatedProgressIndicator> createState() => _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with TickerProviderStateMixin {

  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  double _lastProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _lastProgress = widget.progress;
  }

  void _initializeAnimations() {
    // Progress animation
    _progressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: widget.animationCurve,
    ));

    // Pulse animation
    _pulseController = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }

    _progressController.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.progress != oldWidget.progress) {
      _progressAnimation = Tween<double>(
        begin: _lastProgress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: widget.animationCurve,
      ));
      
      _lastProgress = widget.progress;
      _progressController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? 
                          theme.colorScheme.outline.withOpacity(0.2);
    final progressColor = widget.progressColor ?? theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        AnimatedBuilder(
          animation: Listenable.merge([_progressAnimation, _pulseAnimation]),
          builder: (context, child) {
            final progress = _progressAnimation.value.clamp(0.0, 1.0);
            final pulseScale = widget.enablePulse ? _pulseAnimation.value : 1.0;
            
            return Transform.scale(
              scale: pulseScale,
              child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Stack(
                    children: [
                      // Progress fill
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              progressColor,
                              progressColor.withOpacity(0.8),
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                        transform: Matrix4.translationValues(
                          -(1.0 - progress) * MediaQuery.of(context).size.width,
                          0.0,
                          0.0,
                        ),
                      ),
                      
                      // Glow effect
                      if (widget.enableGlow && progress > 0)
                        Positioned(
                          right: -20,
                          top: -widget.height / 2,
                          bottom: -widget.height / 2,
                          child: Container(
                            width: 40,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  progressColor.withOpacity(0.6),
                                  progressColor.withOpacity(0.0),
                                ],
                              ),
                            ),
                            transform: Matrix4.translationValues(
                              -(1.0 - progress) * MediaQuery.of(context).size.width,
                              0.0,
                              0.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        
        // Percentage text
        if (widget.showPercentage) ...[
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              final percentage = (_progressAnimation.value * 100).round();
              return Text(
                '$percentage%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

/// Circular progress indicator with animations
/// 
/// A circular progress indicator with smooth animations,
/// customizable appearance, and optional center content.
class AnimatedCircularProgress extends StatefulWidget {
  /// Creates an animated circular progress indicator
  const AnimatedCircularProgress({
    super.key,
    required this.progress,
    this.size = 120.0,
    this.strokeWidth = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.animationDuration = AnimationConstants.standardDuration,
    this.animationCurve = AnimationCurves.gentleSpring,
    this.enablePulse = false,
    this.enableRotation = false,
    this.rotationDuration = const Duration(seconds: 2),
    this.centerChild,
    this.showPercentage = true,
  });

  /// Progress value (0.0 to 1.0)
  final double progress;

  /// Size of the circular indicator
  final double size;

  /// Stroke width
  final double strokeWidth;

  /// Background color
  final Color? backgroundColor;

  /// Progress color
  final Color? progressColor;

  /// Animation duration
  final Duration animationDuration;

  /// Animation curve
  final Curve animationCurve;

  /// Whether to enable pulse effect
  final bool enablePulse;

  /// Whether to enable rotation
  final bool enableRotation;

  /// Rotation duration
  final Duration rotationDuration;

  /// Optional center child widget
  final Widget? centerChild;

  /// Whether to show percentage in center
  final bool showPercentage;

  @override
  State<AnimatedCircularProgress> createState() => _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with TickerProviderStateMixin {

  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  double _lastProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _lastProgress = widget.progress;
  }

  void _initializeAnimations() {
    // Progress animation
    _progressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: widget.animationCurve,
    ));

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Rotation animation
    _rotationController = AnimationController(
      duration: widget.rotationDuration,
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rotationController);

    if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }
    
    if (widget.enableRotation) {
      _rotationController.repeat();
    }

    _progressController.forward();
  }

  @override
  void didUpdateWidget(AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.progress != oldWidget.progress) {
      _progressAnimation = Tween<double>(
        begin: _lastProgress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: widget.animationCurve,
      ));
      
      _lastProgress = widget.progress;
      _progressController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? 
                          theme.colorScheme.outline.withOpacity(0.2);
    final progressColor = widget.progressColor ?? theme.colorScheme.primary;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _progressAnimation,
        _pulseAnimation,
        _rotationAnimation,
      ]),
      builder: (context, child) {
        final progress = _progressAnimation.value.clamp(0.0, 1.0);
        final pulseScale = widget.enablePulse ? _pulseAnimation.value : 1.0;
        final rotation = widget.enableRotation ? _rotationAnimation.value * 2 * math.pi : 0.0;
        
        return Transform.scale(
          scale: pulseScale,
          child: Transform.rotate(
            angle: rotation,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: widget.strokeWidth,
                      valueColor: AlwaysStoppedAnimation<Color>(backgroundColor),
                    ),
                  ),
                  
                  // Progress circle
                  SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: widget.strokeWidth,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  
                  // Center content
                  if (widget.centerChild != null)
                    widget.centerChild!
                  else if (widget.showPercentage)
                    Text(
                      '${(progress * 100).round()}%',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Step progress indicator
/// 
/// Shows progress through discrete steps with animations
/// and customizable step appearances.
class StepProgressIndicator extends StatefulWidget {
  /// Creates a step progress indicator
  const StepProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.stepSize = 32.0,
    this.spacing = 8.0,
    this.activeColor,
    this.inactiveColor,
    this.completedColor,
    this.animationDuration = AnimationConstants.standardDuration,
    this.showLabels = false,
    this.stepLabels,
  });

  /// Total number of steps
  final int totalSteps;

  /// Current step index (0-based)
  final int currentStep;

  /// Size of each step indicator
  final double stepSize;

  /// Spacing between steps
  final double spacing;

  /// Color for active step
  final Color? activeColor;

  /// Color for inactive steps
  final Color? inactiveColor;

  /// Color for completed steps
  final Color? completedColor;

  /// Animation duration
  final Duration animationDuration;

  /// Whether to show step labels
  final bool showLabels;

  /// Optional step labels
  final List<String>? stepLabels;

  @override
  State<StepProgressIndicator> createState() => _StepProgressIndicatorState();
}

class _StepProgressIndicatorState extends State<StepProgressIndicator>
    with TickerProviderStateMixin {

  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(widget.totalSteps, (index) {
      return AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: AnimationCurves.gentleSpring,
      ));
    }).toList();
  }

  void _startAnimations() {
    for (int i = 0; i <= widget.currentStep && i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(StepProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.currentStep != oldWidget.currentStep) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      if (i <= widget.currentStep) {
        _controllers[i].forward();
      } else {
        _controllers[i].reverse();
      }
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
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.colorScheme.primary;
    final inactiveColor = widget.inactiveColor ?? theme.colorScheme.outline;
    final completedColor = widget.completedColor ?? theme.colorScheme.secondary;

    return Column(
      children: [
        // Step indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.totalSteps, (index) {
            return _buildStepIndicator(
              index,
              activeColor,
              inactiveColor,
              completedColor,
            );
          }),
        ),
        
        // Step labels
        if (widget.showLabels && widget.stepLabels != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.totalSteps, (index) {
              final label = index < widget.stepLabels!.length 
                  ? widget.stepLabels![index] 
                  : '${index + 1}';
              
              return Container(
                width: widget.stepSize + widget.spacing,
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: index <= widget.currentStep 
                        ? activeColor 
                        : inactiveColor,
                    fontWeight: index == widget.currentStep 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildStepIndicator(
    int index,
    Color activeColor,
    Color inactiveColor,
    Color completedColor,
  ) {
    final isActive = index == widget.currentStep;
    final isCompleted = index < widget.currentStep;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
      child: AnimatedBuilder(
        animation: _animations[index],
        builder: (context, child) {
          final scale = 0.5 + (0.5 * _animations[index].value);
          final opacity = 0.3 + (0.7 * _animations[index].value);
          
          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.stepSize,
              height: widget.stepSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted 
                    ? completedColor.withOpacity(opacity)
                    : isActive 
                        ? activeColor.withOpacity(opacity)
                        : inactiveColor.withOpacity(opacity),
                border: Border.all(
                  color: isActive ? activeColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      size: widget.stepSize * 0.6,
                      color: Colors.white,
                    )
                  : Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isActive || isCompleted 
                              ? Colors.white 
                              : inactiveColor,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.stepSize * 0.4,
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}