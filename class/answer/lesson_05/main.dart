import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Layout Masterclass',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const ProfileGalleryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileGalleryScreen extends StatefulWidget {
  const ProfileGalleryScreen({super.key});

  @override
  State<ProfileGalleryScreen> createState() => _ProfileGalleryScreenState();
}

class _ProfileGalleryScreenState extends State<ProfileGalleryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _layoutTypes = [
    'Business Cards',
    'Social Profiles',
    'Team Grid',
    'Contact Cards',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _layoutTypes.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        ),
        title: const Text(
          '🎨 Layout Masterclass',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => _showLayoutInfo(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: _layoutTypes.map((type) => Tab(text: type)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BusinessCardsTab(),
          SocialProfilesTab(),
          TeamGridTab(),
          ContactCardsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLayoutAnalysis(context),
        icon: const Icon(Icons.analytics_outlined),
        label: const Text('Layout Analysis'),
      ),
    );
  }

  void _showLayoutInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎨 Advanced Layouts'),
        content: const Text(
          'This app demonstrates professional Flutter layout techniques:\n\n'
          '• Complex constraint systems\n'
          '• Responsive design patterns\n'
          '• Advanced widget composition\n'
          '• Professional spacing systems\n'
          '• Performance optimization',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showLayoutAnalysis(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const LayoutAnalysisSheet(),
    );
  }
}

// Business Cards Tab Implementation
class BusinessCardsTab extends StatelessWidget {
  const BusinessCardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(DesignSystem.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Professional Business Cards',
            'Advanced layouts with complex positioning and styling',
          ),
          VSpace(DesignSystem.space6),
          ResponsiveGrid(
            children: _businessCardData.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              return BusinessCard(
                name: data['name']!,
                title: data['title']!,
                company: data['company']!,
                email: data['email']!,
                phone: data['phone']!,
                website: data['website']!,
                cardStyle: BusinessCardStyle.values[index % BusinessCardStyle.values.length],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.2),
        ),
        VSpace(DesignSystem.space2),
        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
        ),
      ],
    );
  }

  static const List<Map<String, String>> _businessCardData = [
    {
      'name': 'Sarah Chen',
      'title': 'Senior Flutter Developer',
      'company': 'TechCorp Inc.',
      'email': 'sarah@techcorp.com',
      'phone': '+1 (555) 123-4567',
      'website': 'sarahchen.dev',
    },
    {
      'name': 'Marcus Johnson',
      'title': 'UX/UI Designer',
      'company': 'Design Studio',
      'email': 'marcus@design.io',
      'phone': '+1 (555) 987-6543',
      'website': 'marcusdesign.com',
    },
    {
      'name': 'Elena Rodriguez',
      'title': 'Product Manager',
      'company': 'Innovation Labs',
      'email': 'elena@innovlabs.com',
      'phone': '+1 (555) 456-7890',
      'website': 'elenapm.pro',
    },
  ];
}

// Social Profiles Tab
class SocialProfilesTab extends StatelessWidget {
  const SocialProfilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(DesignSystem.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Social Profiles', 'Dynamic layouts with staggered positioning'),
          VSpace(DesignSystem.space6),
          StaggeredProfileGrid(profiles: _socialProfileData),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        VSpace(DesignSystem.space2),
        Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ],
    );
  }

  static const List<Map<String, dynamic>> _socialProfileData = [
    {
      'name': 'Alex Rivera',
      'username': '@alexcodes',
      'bio': 'Flutter developer passionate about creating beautiful mobile experiences',
      'followers': 12500,
      'following': 890,
      'posts': 156,
      'isVerified': true,
      'profileColor': Colors.blue,
    },
    {
      'name': 'Maya Patel',
      'username': '@mayaui',
      'bio': 'UI/UX Designer crafting intuitive digital experiences',
      'followers': 8200,
      'following': 1200,
      'posts': 89,
      'isVerified': false,
      'profileColor': Colors.pink,
    },
  ];
}

// Team Grid and Contact Cards (placeholder implementations)
class TeamGridTab extends StatelessWidget {
  const TeamGridTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(DesignSystem.space10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_outlined, size: 80, color: Colors.grey[400]),
            VSpace(DesignSystem.space5),
            const Text('Team Grid Layout', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            VSpace(DesignSystem.space3),
            Text(
              'Advanced grid layouts with\ndynamic content sizing',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactCardsTab extends StatelessWidget {
  const ContactCardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(DesignSystem.space10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contact_phone_outlined, size: 80, color: Colors.grey[400]),
            VSpace(DesignSystem.space5),
            const Text('Contact Cards', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            VSpace(DesignSystem.space3),
            Text(
              'Interactive contact layouts with\nanimated interactions',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

// Design System
class DesignSystem {
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
  static const double space12 = 48;
  static const double space16 = 64;

  static const double radiusXs = 2;
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radius2xl = 24;

  static List<BoxShadow> shadowSm = [
    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1)),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 10)),
  ];
}

// Spacing Widgets
class VSpace extends StatelessWidget {
  final double height;
  const VSpace(this.height, {super.key});
  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class HSpace extends StatelessWidget {
  final double width;
  const HSpace(this.width, {super.key});
  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}

// Responsive Grid
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.childAspectRatio = 1.8,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;
        if (constraints.maxWidth > 600) columns = 2;
        if (constraints.maxWidth > 900) columns = 3;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: DesignSystem.space5,
            crossAxisSpacing: DesignSystem.space4,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

// Business Card Implementation
enum BusinessCardStyle { modern, elegant, creative, minimal }

class BusinessCard extends StatelessWidget {
  final String name, title, company, email, phone, website;
  final BusinessCardStyle cardStyle;

  const BusinessCard({
    super.key,
    required this.name,
    required this.title,
    required this.company,
    required this.email,
    required this.phone,
    required this.website,
    required this.cardStyle,
  });

  @override
  Widget build(BuildContext context) {
    switch (cardStyle) {
      case BusinessCardStyle.modern:
        return _buildModernCard();
      case BusinessCardStyle.elegant:
        return _buildElegantCard();
      case BusinessCardStyle.creative:
        return _buildCreativeCard();
      case BusinessCardStyle.minimal:
        return _buildMinimalCard();
    }
  }

  Widget _buildModernCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignSystem.radius2xl),
        boxShadow: DesignSystem.shadowLg,
      ),
      child: Stack(
        children: [
          Positioned(
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
          ),
          Padding(
            padding: EdgeInsets.all(DesignSystem.space6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignSystem.space3,
                        vertical: DesignSystem.space1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(DesignSystem.space5),
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
                ),
                const Spacer(),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  company,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                VSpace(DesignSystem.space4),
                Row(
                  children: [
                    Expanded(child: _buildContactItem(Icons.email_outlined, email)),
                    HSpace(DesignSystem.space4),
                    Expanded(child: _buildContactItem(Icons.language, website)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignSystem.radiusXl),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: DesignSystem.shadowMd,
      ),
      child: Padding(
        padding: EdgeInsets.all(DesignSystem.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                  ),
                  child: Icon(Icons.business_center_outlined, color: Colors.grey[600], size: 24),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      company.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
                height: 1.3,
              ),
            ),
            VSpace(DesignSystem.space1),
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
            ),
            VSpace(DesignSystem.space5),
            Column(
              children: [
                _buildElegantContactRow(Icons.email_outlined, email),
                VSpace(DesignSystem.space2),
                _buildElegantContactRow(Icons.phone_outlined, phone),
                VSpace(DesignSystem.space2),
                _buildElegantContactRow(Icons.language, website),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreativeCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignSystem.radius2xl),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignSystem.radius2xl),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFF4ECDC4), Color(0xFF45B7D1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
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
            Padding(
              padding: EdgeInsets.all(DesignSystem.space6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
                        ),
                      ),
                      HSpace(DesignSystem.space3),
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
                  ),
                  const Spacer(),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  VSpace(DesignSystem.space1),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignSystem.space3,
                      vertical: DesignSystem.space1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  VSpace(DesignSystem.space4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCreativeContact('EMAIL', email),
                      VSpace(DesignSystem.space2),
                      _buildCreativeContact('WEB', website),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(DesignSystem.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                ),
                HSpace(DesignSystem.space2),
                Text(
                  company.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            VSpace(DesignSystem.space1),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black87),
            ),
            VSpace(DesignSystem.space6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black54),
                ),
                VSpace(DesignSystem.space1),
                Text(
                  website,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.white.withOpacity(0.8)),
        HSpace(DesignSystem.space1),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildElegantContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        HSpace(DesignSystem.space3),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildCreativeContact(String label, String value) {
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
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// Staggered Profile Grid
class StaggeredProfileGrid extends StatelessWidget {
  final List<Map<String, dynamic>> profiles;

  const StaggeredProfileGrid({super.key, required this.profiles});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: profiles.asMap().entries.map((entry) {
        final index = entry.key;
        final profile = entry.value;

        return Padding(
          padding: EdgeInsets.only(
            bottom: DesignSystem.space5,
            left: index % 2 == 0 ? 0 : DesignSystem.space5,
            right: index % 2 == 1 ? 0 : DesignSystem.space5,
          ),
          child: SocialProfileCard(
            name: profile['name'],
            username: profile['username'],
            bio: profile['bio'],
            followers: profile['followers'],
            following: profile['following'],
            posts: profile['posts'],
            isVerified: profile['isVerified'],
            profileColor: profile['profileColor'],
          ),
        );
      }).toList(),
    );
  }
}

// Social Profile Card
class SocialProfileCard extends StatefulWidget {
  final String name, username, bio;
  final int followers, following, posts;
  final bool isVerified;
  final Color profileColor;

  const SocialProfileCard({
    super.key,
    required this.name,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.posts,
    required this.isVerified,
    required this.profileColor,
  });

  @override
  State<SocialProfileCard> createState() => _SocialProfileCardState();
}

class _SocialProfileCardState extends State<SocialProfileCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignSystem.radius2xl),
                boxShadow: [
                  BoxShadow(
                    color: widget.profileColor.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(DesignSystem.space6),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [widget.profileColor, widget.profileColor.withOpacity(0.7)],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.profileColor.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.person, color: Colors.white, size: 35),
                            ),
                            if (widget.isVerified)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                                ),
                              ),
                          ],
                        ),
                        HSpace(DesignSystem.space4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.2),
                              ),
                              Text(
                                widget.username,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_horiz, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                    VSpace(DesignSystem.space5),
                    Text(
                      widget.bio,
                      style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF374151)),
                      textAlign: TextAlign.center,
                    ),
                    VSpace(DesignSystem.space6),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignSystem.space5,
                        vertical: DesignSystem.space4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(DesignSystem.radiusXl),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Posts', widget.posts),
                          _buildStatDivider(),
                          _buildStatItem('Followers', widget.followers),
                          _buildStatDivider(),
                          _buildStatItem('Following', widget.following),
                        ],
                      ),
                    ),
                    VSpace(DesignSystem.space5),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isFollowing = !_isFollowing;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isFollowing ? Colors.grey[200] : widget.profileColor,
                              foregroundColor: _isFollowing ? Colors.grey[700] : Colors.white,
                              padding: EdgeInsets.symmetric(vertical: DesignSystem.space3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _isFollowing ? 'Following' : 'Follow',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        HSpace(DesignSystem.space3),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: DesignSystem.space3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                              ),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            child: const Text(
                              'Message',
                              style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          _formatNumber(value),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 30, color: Colors.grey[300]);
  }

  String _formatNumber(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }
}

// Layout Analysis Sheet
class LayoutAnalysisSheet extends StatefulWidget {
  const LayoutAnalysisSheet({super.key});

  @override
  State<LayoutAnalysisSheet> createState() => _LayoutAnalysisSheetState();
}

class _LayoutAnalysisSheetState extends State<LayoutAnalysisSheet> {
  int _selectedAnalysisType = 0;

  final List<Map<String, dynamic>> _analysisTypes = [
    {
      'title': 'Constraints',
      'icon': Icons.crop_free,
      'description': 'How widgets determine their size and position in Flutter',
      'examples': [
        'BoxConstraints flow down from parent to child',
        'Children report their size back to parent',
        'Parent assigns final position to children',
        'Tight constraints force exact sizes',
        'Loose constraints allow flexible sizing',
      ],
    },
    {
      'title': 'Responsive',
      'icon': Icons.devices,
      'description': 'Adapting layouts to different screen sizes and orientations',
      'examples': [
        'MediaQuery provides screen dimensions and properties',
        'LayoutBuilder gives parent constraint information',
        'Breakpoint systems for different device categories',
        'Flexible layouts that adapt to available space',
        'Orientation-aware design patterns',
      ],
    },
    {
      'title': 'Performance',
      'icon': Icons.speed,
      'description': 'Optimizing layout performance for smooth user experiences',
      'examples': [
        'const constructors prevent unnecessary rebuilds',
        'Widget extraction reduces rebuild scope',
        'RepaintBoundary isolates expensive widgets',
        'ListView.builder for efficient list rendering',
        'Minimal widget tree depth improves performance',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: DesignSystem.space2),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(DesignSystem.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Layout Analysis',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    VSpace(DesignSystem.space2),
                    Text(
                      'Deep dive into Flutter layout concepts and best practices',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: DesignSystem.space5),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _analysisTypes.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedAnalysisType;
                    final analysisType = _analysisTypes[index];

                    return GestureDetector(
                      onTap: () => setState(() => _selectedAnalysisType = index),
                      child: Container(
                        width: 120,
                        margin: EdgeInsets.only(right: DesignSystem.space3),
                        padding: EdgeInsets.all(DesignSystem.space3),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
                          borderRadius: BorderRadius.circular(DesignSystem.radiusXl),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              analysisType['icon'],
                              color: isSelected ? Colors.white : Colors.grey[600],
                              size: 24,
                            ),
                            VSpace(DesignSystem.space1),
                            Text(
                              analysisType['title'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(DesignSystem.space5),
                  children: [
                    Container(
                      padding: EdgeInsets.all(DesignSystem.space5),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(DesignSystem.radiusXl),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _analysisTypes[_selectedAnalysisType]['icon'],
                                color: Colors.blue[700],
                                size: 28,
                              ),
                              HSpace(DesignSystem.space3),
                              Expanded(
                                child: Text(
                                  _analysisTypes[_selectedAnalysisType]['title'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          VSpace(DesignSystem.space3),
                          Text(
                            _analysisTypes[_selectedAnalysisType]['description'],
                            style: TextStyle(fontSize: 16, color: Colors.blue[800], height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    VSpace(DesignSystem.space6),
                    const Text(
                      'Key Concepts:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    VSpace(DesignSystem.space4),
                    ...(_analysisTypes[_selectedAnalysisType]['examples'] as List<String>)
                        .map((example) => Padding(
                              padding: EdgeInsets.only(bottom: DesignSystem.space3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: EdgeInsets.only(
                                      top: DesignSystem.space2,
                                      right: DesignSystem.space3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      example,
                                      style: const TextStyle(fontSize: 16, height: 1.5),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}