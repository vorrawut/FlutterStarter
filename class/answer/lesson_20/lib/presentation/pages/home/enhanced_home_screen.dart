import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/fcm_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth_widgets.dart';
import '../../widgets/notification_widgets.dart';

class EnhancedHomeScreen extends ConsumerStatefulWidget {
  const EnhancedHomeScreen({super.key});

  @override
  ConsumerState<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends ConsumerState<EnhancedHomeScreen> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final displayName = ref.watch(userDisplayNameProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hub,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            const Text('SocialHub Pro Enhanced'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotificationsDemo(context),
          ),
          const UserProfileAvatar(showOnlineIndicator: true),
          const SizedBox(width: 8),
          const SignOutButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Email verification banner
          const EmailVerificationBanner(),
          
          // Main content
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomeTab(),
                _buildCloudFunctionsTab(),
                _buildNotificationsTab(),
                _buildSettingsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Functions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
  
  Widget _buildHomeTab() {
    final user = ref.watch(currentUserProvider);
    final displayName = ref.watch(userDisplayNameProvider);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Welcome section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const UserProfileAvatar(size: 80),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome, $displayName!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Enhanced status chips
                  Wrap(
                    spacing: 8,
                    children: [
                      if (user?.emailVerified == true)
                        Chip(
                          avatar: const Icon(Icons.verified, size: 16),
                          label: const Text('Verified'),
                          backgroundColor: Colors.green.shade100,
                        ),
                      if (user?.isAnonymous == true)
                        Chip(
                          avatar: const Icon(Icons.person_outline, size: 16),
                          label: const Text('Guest'),
                          backgroundColor: Colors.orange.shade100,
                        ),
                      Chip(
                        avatar: const Icon(Icons.cloud, size: 16),
                        label: const Text('Cloud Ready'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                      Chip(
                        avatar: const Icon(Icons.notifications_active, size: 16),
                        label: const Text('FCM Active'),
                        backgroundColor: Colors.purple.shade100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Enhanced features showcase
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _FeatureCard(
                  icon: Icons.post_add,
                  title: 'Create Posts',
                  description: 'Share your thoughts with real-time notifications',
                  gradient: [Colors.blue, Colors.blueAccent],
                  onTap: () => _showComingSoon(context),
                ),
                _FeatureCard(
                  icon: Icons.cloud_queue,
                  title: 'Cloud Functions',
                  description: 'Serverless backend automation',
                  gradient: [Colors.purple, Colors.purpleAccent],
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                _FeatureCard(
                  icon: Icons.notifications_active,
                  title: 'Push Notifications',
                  description: 'Real-time engagement alerts',
                  gradient: [Colors.orange, Colors.deepOrange],
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                _FeatureCard(
                  icon: Icons.analytics,
                  title: 'Analytics',
                  description: 'Real-time insights and metrics',
                  gradient: [Colors.green, Colors.lightGreen],
                  onTap: () => _showComingSoon(context),
                ),
                _FeatureCard(
                  icon: Icons.people,
                  title: 'Social Features',
                  description: 'Connect with automated workflows',
                  gradient: [Colors.pink, Colors.pinkAccent],
                  onTap: () => _showComingSoon(context),
                ),
                _FeatureCard(
                  icon: Icons.settings,
                  title: 'Enhanced Settings',
                  description: 'Cloud-powered preferences',
                  gradient: [Colors.teal, Colors.tealAccent],
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCloudFunctionsTab() {
    return const CloudFunctionsDemo();
  }
  
  Widget _buildNotificationsTab() {
    return const NotificationsDemo();
  }
  
  Widget _buildSettingsTab() {
    return const EnhancedSettingsTab();
  }
  
  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.rocket_launch, color: Colors.white),
            SizedBox(width: 8),
            Text('Coming soon with enhanced cloud features!'),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _showNotificationsDemo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const NotificationDemoSheet(),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: gradient.map((c) => c.withOpacity(0.1)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
