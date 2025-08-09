import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/spacing.dart';
import '../../domain/entities/business_card.dart';

/// Reusable business card widget that displays different card styles
/// Demonstrates component composition and style polymorphism
class BusinessCardWidget extends StatefulWidget {
  final BusinessCard businessCard;
  final VoidCallback? onTap;
  final bool isInteractive;

  const BusinessCardWidget({
    super.key,
    required this.businessCard,
    this.onTap,
    this.isInteractive = true,
  });

  @override
  State<BusinessCardWidget> createState() => _BusinessCardWidgetState();
}

class _BusinessCardWidgetState extends State<BusinessCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.animationFast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isInteractive) {
      return _buildCardContent();
    }

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildCardContent(),
          );
        },
      ),
    );
  }

  Widget _buildCardContent() {
    switch (widget.businessCard.style) {
      case BusinessCardStyle.modern:
        return _ModernCard(businessCard: widget.businessCard);
      case BusinessCardStyle.elegant:
        return _ElegantCard(businessCard: widget.businessCard);
      case BusinessCardStyle.creative:
        return _CreativeCard(businessCard: widget.businessCard);
      case BusinessCardStyle.minimal:
        return _MinimalCard(businessCard: widget.businessCard);
    }
  }
}

/// Modern business card style with gradient background
class _ModernCard extends StatelessWidget {
  final BusinessCard businessCard;

  const _ModernCard({required this.businessCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.modernGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radius2xl),
        boxShadow: AppConstants.shadowLg,
      ),
      child: Stack(
        children: [
          _buildBackgroundPattern(),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned(
      top: -50,
      right: -50,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: AppPadding.all2xl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Spacer(),
          _buildPersonalInfo(context),
          Spacing.verticalLg,
          _buildContactInfo(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ),
        ),
        const Spacer(),
        Container(
          padding: AppPadding.buttonCompact,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          ),
          child: const Text(
            'DEVELOPER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          businessCard.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        Text(
          businessCard.title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          businessCard.company,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Row(
      children: [
        Expanded(
          child: _ContactItem(
            icon: Icons.email_outlined,
            text: businessCard.email,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        Spacing.horizontalLg,
        Expanded(
          child: _ContactItem(
            icon: Icons.language,
            text: businessCard.website,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

/// Elegant business card style with clean professional design
class _ElegantCard extends StatelessWidget {
  final BusinessCard businessCard;

  const _ElegantCard({required this.businessCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: AppConstants.shadowMd,
      ),
      child: Padding(
        padding: AppPadding.all2xl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const Spacer(),
            _buildPersonalInfo(context),
            Spacing.verticalXl,
            _buildContactList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Icon(
            Icons.business_center_outlined,
            color: AppColors.neutral600,
            size: 24,
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              businessCard.company.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.neutral500,
                letterSpacing: 1.2,
              ),
            ),
            Container(
              width: 40,
              height: 2,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          businessCard.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.neutral800,
            height: 1.3,
          ),
        ),
        Spacing.verticalXs,
        Text(
          businessCard.title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.neutral600,
          ),
        ),
      ],
    );
  }

  Widget _buildContactList() {
    return Column(
      children: [
        _ContactRow(
          icon: Icons.email_outlined,
          text: businessCard.email,
        ),
        Spacing.verticalSm,
        _ContactRow(
          icon: Icons.phone_outlined,
          text: businessCard.phone,
        ),
        Spacing.verticalSm,
        _ContactRow(
          icon: Icons.language,
          text: businessCard.website,
        ),
      ],
    );
  }
}

/// Creative business card style with artistic design
class _CreativeCard extends StatelessWidget {
  final BusinessCard businessCard;

  const _CreativeCard({required this.businessCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radius2xl),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radius2xl),
        child: Stack(
          children: [
            _buildGradientBackground(),
            _buildGeometricPatterns(),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.creativeGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildGeometricPatterns() {
    return Stack(
      children: [
        Positioned(
          top: -30,
          right: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -20,
          left: -20,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.radiusXl),
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: AppPadding.all2xl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCreativeHeader(),
          const Spacer(),
          _buildPersonalInfo(context),
          Spacing.verticalLg,
          _buildCreativeContact(),
        ],
      ),
    );
  }

  Widget _buildCreativeHeader() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
        ),
        Spacing.horizontalMd,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CREATIVE',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            Text(
              'PORTFOLIO',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          businessCard.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        Spacing.verticalXs,
        Container(
          padding: AppPadding.buttonCompact,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Text(
            businessCard.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreativeContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CreativeContactItem(
          label: 'EMAIL',
          value: businessCard.email,
        ),
        Spacing.verticalSm,
        _CreativeContactItem(
          label: 'WEB',
          value: businessCard.website,
        ),
      ],
    );
  }
}

/// Minimal business card style with typography focus
class _MinimalCard extends StatelessWidget {
  final BusinessCard businessCard;

  const _MinimalCard({required this.businessCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.neutral300, width: 0.5),
      ),
      child: Padding(
        padding: AppPadding.all3xl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMinimalHeader(),
            const Spacer(),
            _buildPersonalInfo(context),
            Spacing.vertical2xl,
            _buildMinimalContact(),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalHeader() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        Spacing.horizontalSm,
        Text(
          businessCard.company.toUpperCase(),
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          businessCard.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w300,
            color: Colors.black,
            height: 1.2,
          ),
        ),
        Spacing.verticalXs,
        Text(
          businessCard.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          businessCard.email,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        Spacing.verticalXs,
        Text(
          businessCard.website,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

/// Reusable contact item widget
class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ContactItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        Spacing.horizontalXs,
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Contact row for elegant style
class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.neutral500),
        Spacing.horizontalMd,
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.neutral600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Creative contact item
class _CreativeContactItem extends StatelessWidget {
  final String label;
  final String value;

  const _CreativeContactItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 8,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}