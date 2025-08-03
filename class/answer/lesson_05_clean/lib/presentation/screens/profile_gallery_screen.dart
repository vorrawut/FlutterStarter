import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/spacing.dart';
import '../../core/utils/responsive.dart';
import '../../data/datasources/business_card_datasource.dart';
import '../../data/repositories/business_card_repository_impl.dart';
import '../../domain/usecases/get_business_cards_usecase.dart';
import '../controllers/business_cards_controller.dart';
import '../widgets/business_cards_tab.dart';
import '../widgets/layout_analysis_sheet.dart';

/// Main screen for the profile gallery application
/// Demonstrates clean architecture with proper separation of concerns
class ProfileGalleryScreen extends StatefulWidget {
  const ProfileGalleryScreen({super.key});

  @override
  State<ProfileGalleryScreen> createState() => _ProfileGalleryScreenState();
}

class _ProfileGalleryScreenState extends State<ProfileGalleryScreen>
    with TickerProviderStateMixin, ResponsiveMixin {
  late TabController _tabController;
  late BusinessCardsController _businessCardsController;

  final List<String> _layoutTypes = [
    AppStrings.businessCardsTab,
    AppStrings.socialProfilesTab,
    AppStrings.teamGridTab,
    AppStrings.contactCardsTab,
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupTabController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _businessCardsController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    // Initialize data layer
    final dataSource = LocalBusinessCardDataSource();
    final repository = BusinessCardRepositoryImpl(dataSource);
    final useCase = GetBusinessCardsUseCase(repository);
    
    // Initialize presentation layer
    _businessCardsController = BusinessCardsController(useCase);
  }

  void _setupTabController() {
    _tabController = TabController(
      length: _layoutTypes.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _businessCardsController),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      title: Text(
        '🎨 Layout Masterclass',
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: responsive(
            mobile: 20.0,
            tablet: 24.0,
            desktop: 28.0,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.palette_outlined),
          onPressed: () => _showLayoutInfo(),
          tooltip: 'Layout Information',
        ),
      ],
      bottom: _buildTabBar(),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: responsive(
          mobile: 12.0,
          tablet: 14.0,
          desktop: 16.0,
        ),
      ),
      padding: ResponsiveUtils.getResponsivePadding(context),
      tabs: _layoutTypes.map((type) => Tab(text: type)).toList(),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        const BusinessCardsTab(),
        _buildSocialProfilesTab(),
        _buildTeamGridTab(),
        _buildContactCardsTab(),
      ],
    );
  }

  Widget _buildSocialProfilesTab() {
    return Center(
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: responsive(
                mobile: 60.0,
                tablet: 80.0,
                desktop: 100.0,
              ),
              color: Theme.of(context).colorScheme.outline,
            ),
            Spacing.responsiveVertical(context),
            Text(
              AppStrings.socialProfilesHeader,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.verticalMd,
            Text(
              AppStrings.socialProfilesSubheader,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.responsiveVertical(context),
            _buildComingSoonChip(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamGridTab() {
    return Center(
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              size: responsive(
                mobile: 60.0,
                tablet: 80.0,
                desktop: 100.0,
              ),
              color: Theme.of(context).colorScheme.outline,
            ),
            Spacing.responsiveVertical(context),
            Text(
              AppStrings.teamGridPlaceholder,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.verticalMd,
            Text(
              AppStrings.teamGridDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.responsiveVertical(context),
            _buildComingSoonChip(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCardsTab() {
    return Center(
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contact_phone_outlined,
              size: responsive(
                mobile: 60.0,
                tablet: 80.0,
                desktop: 100.0,
              ),
              color: Theme.of(context).colorScheme.outline,
            ),
            Spacing.responsiveVertical(context),
            Text(
              AppStrings.contactCardsPlaceholder,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.verticalMd,
            Text(
              AppStrings.contactCardsDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.responsiveVertical(context),
            _buildComingSoonChip(),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoonChip() {
    return Container(
      padding: AppPadding.buttonCompact,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
      ),
      child: Text(
        '🚀 Coming Soon',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showLayoutAnalysis,
      icon: const Icon(Icons.analytics_outlined),
      label: Text(AppStrings.layoutAnalysis),
      tooltip: 'Analyze Layout Patterns',
    );
  }

  void _showLayoutInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.layoutInfoTitle),
        content: const Text(AppStrings.layoutInfoContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.gotIt),
          ),
        ],
      ),
    );
  }

  void _showLayoutAnalysis() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LayoutAnalysisSheet(),
    );
  }
}

/// Custom page route for smooth navigation
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  CustomPageRoute({
    required this.child,
    this.duration = AppConstants.animationNormal,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

/// Extension to add navigation helpers
extension NavigationExtension on BuildContext {
  Future<T?> pushCustomRoute<T>(Widget page) {
    return Navigator.of(this).push<T>(
      CustomPageRoute(child: page),
    );
  }

  void popRoute() {
    Navigator.of(this).pop();
  }
}