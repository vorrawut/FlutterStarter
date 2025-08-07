import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final displayName = ref.watch(userDisplayNameProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('SocialHub Pro'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
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
            child: Padding(
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
                          
                          // User status chips
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
                                avatar: const Icon(Icons.circle, size: 8),
                                label: const Text('Online'),
                                backgroundColor: Colors.blue.shade100,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Features showcase
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _FeatureCard(
                          icon: Icons.post_add,
                          title: 'Create Posts',
                          description: 'Share your thoughts with the world',
                          onTap: () => _showComingSoon(context),
                        ),
                        _FeatureCard(
                          icon: Icons.people,
                          title: 'Find Friends',
                          description: 'Connect with like-minded people',
                          onTap: () => _showComingSoon(context),
                        ),
                        _FeatureCard(
                          icon: Icons.chat,
                          title: 'Chat',
                          description: 'Real-time messaging',
                          onTap: () => _showComingSoon(context),
                        ),
                        _FeatureCard(
                          icon: Icons.notifications,
                          title: 'Notifications',
                          description: 'Stay updated with activities',
                          onTap: () => _showComingSoon(context),
                        ),
                        _FeatureCard(
                          icon: Icons.explore,
                          title: 'Explore',
                          description: 'Discover trending content',
                          onTap: () => _showComingSoon(context),
                        ),
                        _FeatureCard(
                          icon: Icons.settings,
                          title: 'Settings',
                          description: 'Customize your experience',
                          onTap: () => _showAccountSettings(context, ref),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }
  
  void _showAccountSettings(BuildContext context, WidgetRef ref) {
    final authStatus = ref.read(authActionsProvider).getAuthStatus();
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _InfoRow('User ID', authStatus['uid'] ?? 'N/A'),
            _InfoRow('Email', authStatus['email'] ?? 'N/A'),
            _InfoRow('Display Name', authStatus['displayName'] ?? 'N/A'),
            _InfoRow('Email Verified', authStatus['isEmailVerified'].toString()),
            _InfoRow('Anonymous', authStatus['isAnonymous'].toString()),
            _InfoRow('MFA Enabled', authStatus['isMFAEnabled'].toString()),
            _InfoRow('Primary Provider', authStatus['primaryProvider'] ?? 'N/A'),
            _InfoRow('Providers', (authStatus['providers'] as List).join(', ')),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      try {
                        await ref.read(authActionsProvider).reloadUser();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account information refreshed'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to refresh: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Refresh'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
