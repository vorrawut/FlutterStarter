/// Hero button with micro-interactions
/// 
/// This file provides an enhanced button with sophisticated micro-interactions,
/// hero animations, and delightful feedback responses.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/animations/animation_mixins.dart';
import '../../core/animations/custom_curves.dart';
import '../../core/constants/animation_constants.dart';

/// Hero button with enhanced micro-interactions
/// 
/// A sophisticated button that provides delightful feedback through
/// animations, haptic feedback, and visual transformations.
class HeroButton extends StatefulWidget {
  /// Creates a hero button
  const HeroButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.heroTag,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.pressedElevation = 8.0,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    this.animationDuration = AnimationConstants.microDuration,
    this.enableHaptics = true,
    this.enableSoundEffects = false,
    this.enableRipple = true,
    this.scaleOnPress = 0.95,
    this.glowColor,
    this.enableGlow = true,
  });

  /// Button press callback
  final VoidCallback? onPressed;

  /// Button child widget
  final Widget child;

  /// Hero tag for hero animations
  final String? heroTag;

  /// Button background color
  final Color? backgroundColor;

  /// Button foreground color
  final Color? foregroundColor;

  /// Default elevation
  final double elevation;

  /// Elevation when pressed
  final double pressedElevation;

  /// Border radius
  final double borderRadius;

  /// Button padding
  final EdgeInsets padding;

  /// Animation duration for micro-interactions
  final Duration animationDuration;

  /// Whether to enable haptic feedback
  final bool enableHaptics;

  /// Whether to enable sound effects
  final bool enableSoundEffects;

  /// Whether to enable ripple effect
  final bool enableRipple;

  /// Scale factor when pressed
  final double scaleOnPress;

  /// Glow color for hover/focus states
  final Color? glowColor;

  /// Whether to enable glow effect
  final bool enableGlow;

  @override
  State<HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<HeroButton>
    with TickerProviderStateMixin, MicroInteractionMixin {

  late AnimationController _scaleController;
  late AnimationController _elevationController;
  late AnimationController _glowController;
  late AnimationController _rippleController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rippleAnimation;

  bool _isPressed = false;
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Scale animation for press effect
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnPress,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // Elevation animation
    _elevationController = AnimationController(
      duration: widget.animationDuration * 2,
      vsync: this,
    );
    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.pressedElevation,
    ).animate(CurvedAnimation(
      parent: _elevationController,
      curve: AnimationCurves.gentleSpring,
    ));

    // Glow animation for hover/focus
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeOut,
    ));

    // Ripple animation
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _elevationController.dispose();
    _glowController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  /// Handle press down
  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;

    setState(() {
      _isPressed = true;
    });

    _scaleController.forward();
    
    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }

    if (widget.enableRipple) {
      _rippleController.forward(from: 0.0);
    }
  }

  /// Handle press up
  void _handleTapUp(TapUpDetails details) {
    _handlePressRelease();
    
    if (widget.onPressed != null) {
      _elevationController.forward().then((_) {
        _elevationController.reverse();
      });
      
      if (widget.enableHaptics) {
        HapticFeedback.selectionClick();
      }
      
      widget.onPressed!();
    }
  }

  /// Handle press cancel
  void _handleTapCancel() {
    _handlePressRelease();
  }

  /// Handle press release
  void _handlePressRelease() {
    setState(() {
      _isPressed = false;
    });

    _scaleController.reverse();
  }

  /// Handle hover
  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (widget.enableGlow) {
      if (isHovered) {
        _glowController.forward();
      } else {
        _glowController.reverse();
      }
    }
  }

  /// Handle focus
  void _handleFocus(bool isFocused) {
    setState(() {
      _isFocused = isFocused;
    });

    if (widget.enableGlow) {
      if (isFocused) {
        _glowController.forward();
      } else if (!_isHovered) {
        _glowController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = widget.backgroundColor ?? colorScheme.primary;
    final foregroundColor = widget.foregroundColor ?? colorScheme.onPrimary;
    final glowColor = widget.glowColor ?? backgroundColor;

    Widget button = AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _elevationAnimation,
        _glowAnimation,
        _rippleAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                // Main shadow
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: _elevationAnimation.value * 2,
                  offset: Offset(0, _elevationAnimation.value),
                ),
                // Glow effect
                if (widget.enableGlow && _glowAnimation.value > 0)
                  BoxShadow(
                    color: glowColor.withOpacity(0.3 * _glowAnimation.value),
                    blurRadius: 20 * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // Main button content
                Container(
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: foregroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                    child: IconTheme(
                      data: IconThemeData(
                        color: foregroundColor,
                        size: 20,
                      ),
                      child: child!,
                    ),
                  ),
                ),
                
                // Ripple effect
                if (widget.enableRipple && _rippleAnimation.value > 0)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        color: foregroundColor.withOpacity(
                          0.1 * (1 - _rippleAnimation.value),
                        ),
                      ),
                      child: Transform.scale(
                        scale: _rippleAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                            border: Border.all(
                              color: foregroundColor.withOpacity(
                                0.3 * (1 - _rippleAnimation.value),
                              ),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      child: widget.child,
    );

    // Wrap with gesture detection
    button = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: Focus(
          onFocusChange: _handleFocus,
          child: button,
        ),
      ),
    );

    // Wrap with hero if tag is provided
    if (widget.heroTag != null) {
      button = Hero(
        tag: widget.heroTag!,
        child: button,
      );
    }

    return button;
  }
}

/// Floating hero button for prominent actions
/// 
/// An enhanced floating action button with sophisticated animations
/// and micro-interactions.
class FloatingHeroButton extends StatefulWidget {
  /// Creates a floating hero button
  const FloatingHeroButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.heroTag = 'floating_hero_button',
    this.backgroundColor,
    this.foregroundColor,
    this.size = 56.0,
    this.elevation = 6.0,
    this.pressedElevation = 12.0,
    this.enablePulse = false,
    this.pulseDuration = const Duration(seconds: 2),
  });

  /// Button press callback
  final VoidCallback? onPressed;

  /// Button child widget (usually an icon)
  final Widget child;

  /// Hero tag
  final String heroTag;

  /// Background color
  final Color? backgroundColor;

  /// Foreground color
  final Color? foregroundColor;

  /// Button size
  final double size;

  /// Default elevation
  final double elevation;

  /// Pressed elevation
  final double pressedElevation;

  /// Whether to enable pulse animation
  final bool enablePulse;

  /// Pulse animation duration
  final Duration pulseDuration;

  @override
  State<FloatingHeroButton> createState() => _FloatingHeroButtonState();
}

class _FloatingHeroButtonState extends State<FloatingHeroButton>
    with TickerProviderStateMixin {

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    if (widget.enablePulse) {
      _pulseController = AnimationController(
        duration: widget.pulseDuration,
        vsync: this,
      );
      
      _pulseAnimation = Tween<double>(
        begin: 1.0,
        end: 1.1,
      ).animate(CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ));
      
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (widget.enablePulse) {
      _pulseController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = HeroButton(
      onPressed: widget.onPressed,
      heroTag: widget.heroTag,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      elevation: widget.elevation,
      pressedElevation: widget.pressedElevation,
      borderRadius: widget.size / 2,
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Center(child: widget.child),
      ),
    );

    if (widget.enablePulse) {
      button = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: button,
      );
    }

    return button;
  }
}

/// Button animation presets
/// 
/// Collection of predefined animation configurations for common button types.
class ButtonAnimations {
  /// Private constructor
  const ButtonAnimations._();

  /// Primary action button configuration
  static const Duration primaryDuration = Duration(milliseconds: 150);
  static const double primaryScale = 0.95;
  static const double primaryElevation = 8.0;

  /// Secondary action button configuration
  static const Duration secondaryDuration = Duration(milliseconds: 100);
  static const double secondaryScale = 0.98;
  static const double secondaryElevation = 4.0;

  /// Destructive action button configuration
  static const Duration destructiveDuration = Duration(milliseconds: 200);
  static const double destructiveScale = 0.92;
  static const double destructiveElevation = 6.0;

  /// Subtle action button configuration
  static const Duration subtleDuration = Duration(milliseconds: 80);
  static const double subtleScale = 0.99;
  static const double subtleElevation = 2.0;

  /// Success action button configuration
  static const Duration successDuration = Duration(milliseconds: 250);
  static const double successScale = 0.93;
  static const double successElevation = 10.0;
}