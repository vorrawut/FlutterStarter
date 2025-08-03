import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Navigation item entity representing a menu item or tab
class NavigationItem extends Equatable {
  final String id;
  final String route;
  final String title;
  final String? subtitle;
  final IconData icon;
  final IconData? activeIcon;
  final bool requiresAuth;
  final bool enabled;
  final int? badgeCount;
  final Color? badgeColor;
  final List<NavigationItem>? children;
  final NavigationItemType type;
  final int? sortOrder;

  const NavigationItem({
    required this.id,
    required this.route,
    required this.title,
    this.subtitle,
    required this.icon,
    this.activeIcon,
    this.requiresAuth = false,
    this.enabled = true,
    this.badgeCount,
    this.badgeColor,
    this.children,
    this.type = NavigationItemType.page,
    this.sortOrder,
  });

  /// Create a copy with updated properties
  NavigationItem copyWith({
    String? id,
    String? route,
    String? title,
    String? subtitle,
    IconData? icon,
    IconData? activeIcon,
    bool? requiresAuth,
    bool? enabled,
    int? badgeCount,
    Color? badgeColor,
    List<NavigationItem>? children,
    NavigationItemType? type,
    int? sortOrder,
  }) {
    return NavigationItem(
      id: id ?? this.id,
      route: route ?? this.route,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      requiresAuth: requiresAuth ?? this.requiresAuth,
      enabled: enabled ?? this.enabled,
      badgeCount: badgeCount ?? this.badgeCount,
      badgeColor: badgeColor ?? this.badgeColor,
      children: children ?? this.children,
      type: type ?? this.type,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// Update badge count
  NavigationItem updateBadgeCount(int? count) {
    return copyWith(badgeCount: count);
  }

  /// Check if item has children
  bool get hasChildren => children?.isNotEmpty == true;

  /// Check if item has badge
  bool get hasBadge => badgeCount != null && badgeCount! > 0;

  /// Get display badge text
  String get badgeText {
    if (badgeCount == null || badgeCount! <= 0) return '';
    if (badgeCount! > 99) return '99+';
    return badgeCount.toString();
  }

  /// Check if item is a separator
  bool get isSeparator => type == NavigationItemType.separator;

  /// Check if item is a header
  bool get isHeader => type == NavigationItemType.header;

  /// Check if item is actionable (can be tapped)
  bool get isActionable => 
      enabled && 
      type == NavigationItemType.page && 
      !isSeparator && 
      !isHeader;

  @override
  List<Object?> get props => [
        id,
        route,
        title,
        subtitle,
        icon,
        activeIcon,
        requiresAuth,
        enabled,
        badgeCount,
        badgeColor,
        children,
        type,
        sortOrder,
      ];

  @override
  String toString() {
    return 'NavigationItem(id: $id, title: $title, route: $route, requiresAuth: $requiresAuth)';
  }
}

/// Navigation item type enumeration
enum NavigationItemType {
  page('Page'),
  action('Action'),
  separator('Separator'),
  header('Header'),
  external('External Link');

  const NavigationItemType(this.displayName);
  final String displayName;
}

/// Factory class for creating navigation items
class NavigationItemFactory {
  /// Create main bottom navigation items
  static List<NavigationItem> createBottomNavigationItems() {
    return [
      const NavigationItem(
        id: 'home',
        route: '/home',
        title: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        sortOrder: 0,
      ),
      const NavigationItem(
        id: 'products',
        route: '/products',
        title: 'Products',
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag,
        sortOrder: 1,
      ),
      const NavigationItem(
        id: 'cart',
        route: '/cart',
        title: 'Cart',
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart,
        requiresAuth: true,
        sortOrder: 2,
      ),
      const NavigationItem(
        id: 'profile',
        route: '/profile',
        title: 'Profile',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        requiresAuth: true,
        sortOrder: 3,
      ),
    ];
  }

  /// Create drawer navigation items
  static List<NavigationItem> createDrawerNavigationItems() {
    return [
      // Main sections
      const NavigationItem(
        id: 'home_drawer',
        route: '/home',
        title: 'Home',
        icon: Icons.home_outlined,
        type: NavigationItemType.page,
        sortOrder: 0,
      ),
      const NavigationItem(
        id: 'products_drawer',
        route: '/products',
        title: 'Browse Products',
        icon: Icons.shopping_bag_outlined,
        type: NavigationItemType.page,
        sortOrder: 1,
      ),
      const NavigationItem(
        id: 'search_drawer',
        route: '/search',
        title: 'Search',
        icon: Icons.search,
        type: NavigationItemType.page,
        sortOrder: 2,
      ),
      
      // Separator
      const NavigationItem(
        id: 'separator_1',
        route: '',
        title: '',
        icon: Icons.remove,
        type: NavigationItemType.separator,
        sortOrder: 3,
      ),
      
      // Account section (requires auth)
      const NavigationItem(
        id: 'orders_drawer',
        route: '/profile/orders',
        title: 'My Orders',
        icon: Icons.receipt_long_outlined,
        requiresAuth: true,
        type: NavigationItemType.page,
        sortOrder: 4,
      ),
      const NavigationItem(
        id: 'favorites_drawer',
        route: '/profile/favorites',
        title: 'Favorites',
        icon: Icons.favorite_outline,
        requiresAuth: true,
        type: NavigationItemType.page,
        sortOrder: 5,
      ),
      const NavigationItem(
        id: 'addresses_drawer',
        route: '/profile/addresses',
        title: 'Addresses',
        icon: Icons.location_on_outlined,
        requiresAuth: true,
        type: NavigationItemType.page,
        sortOrder: 6,
      ),
      
      // Separator
      const NavigationItem(
        id: 'separator_2',
        route: '',
        title: '',
        icon: Icons.remove,
        type: NavigationItemType.separator,
        sortOrder: 7,
      ),
      
      // Settings and support
      const NavigationItem(
        id: 'settings_drawer',
        route: '/profile/settings',
        title: 'Settings',
        icon: Icons.settings_outlined,
        requiresAuth: true,
        type: NavigationItemType.page,
        sortOrder: 8,
      ),
      const NavigationItem(
        id: 'help_drawer',
        route: '/help',
        title: 'Help & Support',
        icon: Icons.help_outline,
        type: NavigationItemType.page,
        sortOrder: 9,
      ),
      const NavigationItem(
        id: 'about_drawer',
        route: '/about',
        title: 'About',
        icon: Icons.info_outline,
        type: NavigationItemType.page,
        sortOrder: 10,
      ),
    ];
  }

  /// Create profile menu items
  static List<NavigationItem> createProfileMenuItems() {
    return [
      const NavigationItem(
        id: 'profile_main',
        route: '/profile',
        title: 'Profile Information',
        subtitle: 'Manage your account details',
        icon: Icons.person_outline,
        type: NavigationItemType.page,
        sortOrder: 0,
      ),
      const NavigationItem(
        id: 'orders',
        route: '/profile/orders',
        title: 'My Orders',
        subtitle: 'Track and manage your orders',
        icon: Icons.receipt_long_outlined,
        type: NavigationItemType.page,
        sortOrder: 1,
      ),
      const NavigationItem(
        id: 'favorites',
        route: '/profile/favorites',
        title: 'Favorites',
        subtitle: 'Your saved products',
        icon: Icons.favorite_outline,
        type: NavigationItemType.page,
        sortOrder: 2,
      ),
      const NavigationItem(
        id: 'addresses',
        route: '/profile/addresses',
        title: 'Delivery Addresses',
        subtitle: 'Manage shipping addresses',
        icon: Icons.location_on_outlined,
        type: NavigationItemType.page,
        sortOrder: 3,
      ),
      const NavigationItem(
        id: 'payment_methods',
        route: '/profile/payment-methods',
        title: 'Payment Methods',
        subtitle: 'Manage cards and payment options',
        icon: Icons.payment_outlined,
        type: NavigationItemType.page,
        sortOrder: 4,
      ),
      const NavigationItem(
        id: 'notifications',
        route: '/profile/notifications',
        title: 'Notifications',
        subtitle: 'Configure notification preferences',
        icon: Icons.notifications_outlined,
        type: NavigationItemType.page,
        sortOrder: 5,
      ),
      const NavigationItem(
        id: 'settings',
        route: '/profile/settings',
        title: 'Settings',
        subtitle: 'App preferences and privacy',
        icon: Icons.settings_outlined,
        type: NavigationItemType.page,
        sortOrder: 6,
      ),
    ];
  }

  /// Filter navigation items based on authentication status
  static List<NavigationItem> filterByAuthStatus(
    List<NavigationItem> items,
    bool isAuthenticated,
  ) {
    return items.where((item) {
      if (item.requiresAuth && !isAuthenticated) {
        return false;
      }
      return item.enabled;
    }).toList();
  }

  /// Sort navigation items by sort order
  static List<NavigationItem> sortBySortOrder(List<NavigationItem> items) {
    final sortedItems = List<NavigationItem>.from(items);
    sortedItems.sort((a, b) {
      final aOrder = a.sortOrder ?? 999;
      final bOrder = b.sortOrder ?? 999;
      return aOrder.compareTo(bOrder);
    });
    return sortedItems;
  }

  /// Create sample navigation item for testing
  static NavigationItem createSample({
    String? id,
    String? title,
    IconData? icon,
    bool requiresAuth = false,
  }) {
    return NavigationItem(
      id: id ?? 'sample_${DateTime.now().millisecondsSinceEpoch}',
      route: '/sample',
      title: title ?? 'Sample Item',
      icon: icon ?? Icons.star,
      requiresAuth: requiresAuth,
    );
  }
}