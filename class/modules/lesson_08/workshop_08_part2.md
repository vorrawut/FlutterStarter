# 🛠 Lesson 8: Responsive Layouts - Workshop (Part 2)

## **Step 5: Dashboard State Management** ⏱️ *15 minutes*

Create the controller for managing dashboard state:

```dart
// lib/presentation/controllers/dashboard_controller.dart
import 'package:flutter/material.dart';
import '../../core/responsive/screen_size.dart';
import '../../domain/entities/dashboard_item.dart';
import '../../domain/entities/navigation_item.dart';
import '../../data/repositories/dashboard_repository_impl.dart';

/// Controller for managing dashboard state and responsive behavior
class DashboardController extends ChangeNotifier {
  final DashboardRepositoryImpl _repository = DashboardRepositoryImpl();

  List<DashboardItem> _dashboardItems = [];
  List<NavigationItem> _navigationItems = [];
  int _selectedNavigationIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  ScreenSize _currentScreenSize = ScreenSize.mobile;

  // Getters
  List<DashboardItem> get dashboardItems => _dashboardItems;
  List<NavigationItem> get navigationItems => _navigationItems;
  int get selectedNavigationIndex => _selectedNavigationIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ScreenSize get currentScreenSize => _currentScreenSize;

  /// Get filtered dashboard items based on screen size
  List<DashboardItem> get visibleDashboardItems {
    return _dashboardItems.where((item) => item.isVisible).toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
  }

  /// Get grid column count for current screen size
  int get gridColumnCount {
    switch (_currentScreenSize) {
      case ScreenSize.mobile:
        return 1;
      case ScreenSize.tablet:
        return 2;
      case ScreenSize.desktop:
        return 3;
      case ScreenSize.ultrawide:
        return 4;
    }
  }

  /// Initialize dashboard data
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dashboardItems = await _repository.getDashboardItems();
      _navigationItems = _repository.getNavigationItems();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load dashboard: $e';
      _dashboardItems = [];
      _navigationItems = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update screen size and adapt layout
  void updateScreenSize(ScreenSize screenSize) {
    if (_currentScreenSize != screenSize) {
      _currentScreenSize = screenSize;
      notifyListeners();
    }
  }

  /// Handle navigation selection
  void selectNavigation(int index) {
    if (index >= 0 && index < _navigationItems.length) {
      _selectedNavigationIndex = index;
      notifyListeners();
    }
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    await initialize();
  }

  /// Add dashboard item
  void addDashboardItem(DashboardItem item) {
    _dashboardItems.add(item);
    notifyListeners();
  }

  /// Remove dashboard item
  void removeDashboardItem(String id) {
    _dashboardItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Update dashboard item
  void updateDashboardItem(DashboardItem updatedItem) {
    final index = _dashboardItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _dashboardItems[index] = updatedItem;
      notifyListeners();
    }
  }

  /// Toggle dashboard item visibility
  void toggleItemVisibility(String id) {
    final index = _dashboardItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _dashboardItems[index] = _dashboardItems[index].copyWith(
        isVisible: !_dashboardItems[index].isVisible,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
```

## **Step 6: Responsive Dashboard Components** ⏱️ *25 minutes*

Build the adaptive dashboard widgets:

```dart
// lib/presentation/widgets/dashboard_card.dart
import 'package:flutter/material.dart';
import '../../core/responsive/responsive_builder.dart';
import '../../core/responsive/adaptive_widgets.dart';
import '../../domain/entities/dashboard_item.dart';

/// Responsive dashboard card that adapts to screen size
class DashboardCard extends StatelessWidget {
  final DashboardItem item;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        return AdaptiveCard(
          padding: {
            ScreenSize.mobile: const EdgeInsets.all(16),
            ScreenSize.tablet: const EdgeInsets.all(20),
            ScreenSize.desktop: const EdgeInsets.all(24),
            ScreenSize.ultrawide: const EdgeInsets.all(28),
          },
          elevation: {
            ScreenSize.mobile: 2,
            ScreenSize.tablet: 4,
            ScreenSize.desktop: 6,
            ScreenSize.ultrawide: 8,
          },
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: _buildCardContent(context, screenSize),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(BuildContext context, ScreenSize screenSize) {
    switch (item.type) {
      case DashboardItemType.metric:
        return _buildMetricCard(context, screenSize);
      case DashboardItemType.chart:
        return _buildChartCard(context, screenSize);
      case DashboardItemType.list:
        return _buildListCard(context, screenSize);
      default:
        return _buildGenericCard(context, screenSize);
    }
  }

  Widget _buildMetricCard(BuildContext context, ScreenSize screenSize) {
    final data = item.data;
    final value = data['value']?.toString() ?? item.subtitle;
    final change = data['change'] as double?;
    final period = data['period'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (item.color ?? Theme.of(context).primaryColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon,
                color: item.color ?? Theme.of(context).primaryColor,
                size: screenSize == ScreenSize.mobile ? 20 : 24,
              ),
            ),
            const Spacer(),
            if (change != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: change >= 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      change >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: change >= 0 ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${change.abs().toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: change >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ResponsiveText(
          item.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          fontSizeOverrides: {
            ScreenSize.mobile: 14,
            ScreenSize.tablet: 15,
            ScreenSize.desktop: 16,
            ScreenSize.ultrawide: 17,
          },
        ),
        const SizedBox(height: 8),
        ResponsiveText(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          fontSizeOverrides: {
            ScreenSize.mobile: 24,
            ScreenSize.tablet: 28,
            ScreenSize.desktop: 32,
            ScreenSize.ultrawide: 36,
          },
        ),
        if (period != null) ...[
          const SizedBox(height: 4),
          Text(
            period,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChartCard(BuildContext context, ScreenSize screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              item.icon,
              color: item.color ?? Theme.of(context).primaryColor,
              size: screenSize == ScreenSize.mobile ? 20 : 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ResponsiveText(
                item.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          item.subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: screenSize == ScreenSize.mobile ? 120 : 150,
          child: _buildMockChart(context),
        ),
      ],
    );
  }

  Widget _buildListCard(BuildContext context, ScreenSize screenSize) {
    final items = item.data['items'] as List<String>? ?? [];
    final maxItems = screenSize == ScreenSize.mobile ? 3 : 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              item.icon,
              color: item.color ?? Theme.of(context).primaryColor,
              size: screenSize == ScreenSize.mobile ? 20 : 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ResponsiveText(
                item.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.take(maxItems).map((listItem) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      listItem,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )),
        if (items.length > maxItems) ...[
          const SizedBox(height: 8),
          Text(
            '+${items.length - maxItems} more',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGenericCard(BuildContext context, ScreenSize screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              item.icon,
              color: item.color ?? Theme.of(context).primaryColor,
              size: screenSize == ScreenSize.mobile ? 20 : 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ResponsiveText(
                item.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ResponsiveText(
          item.subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildMockChart(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            (item.color ?? Theme.of(context).primaryColor).withOpacity(0.3),
            (item.color ?? Theme.of(context).primaryColor).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'Chart Placeholder',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// lib/presentation/widgets/responsive_grid.dart
import 'package:flutter/material.dart';
import '../../core/responsive/responsive_builder.dart';

/// Advanced responsive grid with staggered layout support
class ResponsiveStaggeredGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final Map<ScreenSize, int>? crossAxisCounts;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ResponsiveStaggeredGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.crossAxisCounts,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final crossAxisCount = crossAxisCounts?[screenSize] ?? screenSize.defaultColumns;
        
        if (crossAxisCount == 1) {
          // Single column layout for mobile
          return ListView.separated(
            physics: physics,
            shrinkWrap: shrinkWrap,
            itemCount: children.length,
            separatorBuilder: (context, index) => SizedBox(height: spacing),
            itemBuilder: (context, index) => children[index],
          );
        }
        
        // Multi-column layout for larger screens
        return _buildStaggeredGrid(crossAxisCount);
      },
    );
  }

  Widget _buildStaggeredGrid(int crossAxisCount) {
    final List<List<Widget>> columns = List.generate(crossAxisCount, (_) => []);
    
    // Distribute children across columns
    for (int i = 0; i < children.length; i++) {
      final columnIndex = i % crossAxisCount;
      columns[columnIndex].add(children[i]);
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns.asMap().entries.map((entry) {
        final columnIndex = entry.key;
        final columnChildren = entry.value;
        
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: columnIndex > 0 ? spacing / 2 : 0,
              right: columnIndex < crossAxisCount - 1 ? spacing / 2 : 0,
            ),
            child: Column(
              children: columnChildren
                  .expand((child) => [child, SizedBox(height: spacing)])
                  .toList()
                ..removeLast(), // Remove last spacing
            ),
          ),
        );
      }).toList(),
    );
  }
}
```

## **Step 7: Main Dashboard Screen** ⏱️ *20 minutes*

Create the main dashboard with adaptive layout:

```dart
// lib/presentation/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/responsive/responsive_builder.dart';
import '../../core/responsive/adaptive_widgets.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/responsive_grid.dart';

/// Main dashboard screen with responsive layout
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, screenSize) {
          // Update screen size in controller
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<DashboardController>().updateScreenSize(screenSize);
          });
          
          return _buildDashboardContent(context, screenSize);
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, ScreenSize screenSize) {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildLoadingState(context);
        }

        if (controller.errorMessage != null) {
          return _buildErrorState(context, controller);
        }

        return _buildDashboard(context, controller, screenSize);
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading dashboard...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, DashboardController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load dashboard',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            controller.errorMessage!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.refresh(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    DashboardController controller,
    ScreenSize screenSize,
  ) {
    return RefreshIndicator(
      onRefresh: () => controller.refresh(),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: ResponsiveText(
              'Dashboard',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            floating: true,
            snap: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.refresh(),
                tooltip: 'Refresh',
              ),
              ResponsiveVisibility.tabletAndUp(
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Navigate to settings
                  },
                  tooltip: 'Settings',
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: context.contentPadding,
            sliver: SliverToBoxAdapter(
              child: _buildDashboardGrid(context, controller, screenSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardGrid(
    BuildContext context,
    DashboardController controller,
    ScreenSize screenSize,
  ) {
    final items = controller.visibleDashboardItems;
    
    return ResponsiveStaggeredGrid(
      crossAxisCounts: {
        ScreenSize.mobile: 1,
        ScreenSize.tablet: 2,
        ScreenSize.desktop: 3,
        ScreenSize.ultrawide: 4,
      },
      spacing: context.spacing(),
      children: items.map((item) => DashboardCard(
        item: item,
        onTap: () => _handleCardTap(context, item),
      )).toList(),
    );
  }

  void _handleCardTap(BuildContext context, item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on ${item.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
```

## **Step 8: Complete App Integration** ⏱️ *15 minutes*

Integrate everything into the main app:

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/responsive/adaptive_widgets.dart';
import 'presentation/controllers/dashboard_controller.dart';
import 'presentation/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI
  await _configureSystemUI();
  
  runApp(const ResponsiveDashboardApp());
}

Future<void> _configureSystemUI() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

class ResponsiveDashboardApp extends StatelessWidget {
  const ResponsiveDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DashboardController(),
        ),
      ],
      child: MaterialApp(
        title: 'Responsive Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.dark,
          ),
        ),
        home: const ResponsiveDashboardHome(),
      ),
    );
  }
}

class ResponsiveDashboardHome extends StatefulWidget {
  const ResponsiveDashboardHome({super.key});

  @override
  State<ResponsiveDashboardHome> createState() => _ResponsiveDashboardHomeState();
}

class _ResponsiveDashboardHomeState extends State<ResponsiveDashboardHome> {
  int _selectedIndex = 0;

  final List<AdaptiveNavigationItem> _navigationItems = [
    const AdaptiveNavigationItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    const AdaptiveNavigationItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Analytics',
    ),
    const AdaptiveNavigationItem(
      icon: Icons.people_outline,
      activeIcon: Icons.people,
      label: 'Customers',
    ),
    const AdaptiveNavigationItem(
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
      label: 'Products',
    ),
    const AdaptiveNavigationItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  final List<Widget> _screens = [
    const DashboardScreen(),
    const Center(child: Text('Analytics Screen')),
    const Center(child: Text('Customers Screen')),
    const Center(child: Text('Products Screen')),
    const Center(child: Text('Settings Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveNavigation(
      items: _navigationItems,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }
}
```

## **Step 9: Testing & Validation** ⏱️ *10 minutes*

Test your responsive dashboard:

### **Manual Testing Checklist**

1. **Screen Size Testing**
   - [ ] Test on mobile devices (320-767px)
   - [ ] Test on tablets (768-1023px)
   - [ ] Test on desktop (1024px+)
   - [ ] Test on ultrawide displays (1440px+)

2. **Navigation Testing**
   - [ ] Bottom navigation on mobile
   - [ ] Navigation rail on tablet
   - [ ] Navigation drawer on desktop
   - [ ] Smooth transitions between layouts

3. **Grid Responsiveness**
   - [ ] Single column on mobile
   - [ ] Two columns on tablet
   - [ ] Three columns on desktop
   - [ ] Four columns on ultrawide

4. **Component Adaptation**
   - [ ] Card padding adjusts
   - [ ] Font sizes scale appropriately
   - [ ] Icons resize properly
   - [ ] Content reflows correctly

5. **Performance Testing**
   - [ ] Smooth animations
   - [ ] No layout jumping
   - [ ] Efficient rebuilds
   - [ ] Memory usage stable

### **Automated Tests**

```dart
// test/responsive_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Responsive Dashboard Tests', () {
    testWidgets('Dashboard adapts to different screen sizes', (tester) async {
      // Test mobile layout
      await tester.binding.setSurfaceSize(const Size(375, 812));
      await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
      
      // Verify mobile-specific elements
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      
      // Test tablet layout
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pump();
      
      // Test desktop layout
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pump();
      
      // Verify desktop-specific elements
      expect(find.byType(NavigationDrawer), findsOneWidget);
    });

    testWidgets('Grid columns adjust to screen size', (tester) async {
      const sizes = [
        Size(320, 568), // Mobile small
        Size(768, 1024), // Tablet
        Size(1200, 800), // Desktop
        Size(1920, 1080), // Ultrawide
      ];

      for (final size in sizes) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
        await tester.pump();
        
        // Verify appropriate layout for screen size
      }
    });
  });
}
```

## 🎉 **Congratulations!**

You've successfully implemented a comprehensive responsive dashboard with:

✅ **Professional Breakpoint System** - Industry-standard responsive framework  
✅ **Adaptive Navigation** - Context-aware navigation patterns  
✅ **Responsive Components** - Cards, grids, and widgets that adapt beautifully  
✅ **Clean Architecture** - Maintainable, scalable responsive code  
✅ **Performance Optimization** - Efficient rendering and smooth transitions  
✅ **Platform Integration** - Native-feeling experiences on all devices

## 🎯 **Next Steps**

- Explore advanced responsive animations
- Add orientation-specific layouts
- Implement responsive images and media
- Create responsive typography systems
- Build adaptive form layouts

**Your responsive dashboard now provides an excellent user experience across all devices and screen sizes! 📱💻🖥️✨**