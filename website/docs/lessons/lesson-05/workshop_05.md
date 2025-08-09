# 🛠 Workshop 05: Advanced Layouts & UI Composition

## 🎯 What We're Building
A sophisticated **Professional Profile Card App** that demonstrates advanced Flutter layout techniques. This comprehensive application will showcase complex UI composition, responsive design patterns, and professional layout strategies used in real-world applications.

## ✅ Expected Outcome
By the end of this workshop, you will:
- ✅ Master advanced layout widgets and composition patterns
- ✅ Build responsive designs that adapt to different screen sizes
- ✅ Create complex, multi-layered UI components
- ✅ Implement professional design systems and spacing
- ✅ Use advanced constraint and positioning techniques
- ✅ Build reusable layout components and design patterns

## 👨‍💻 Steps to Complete

### Step 1: Project Setup & Advanced Layout Foundation

Let's create a sophisticated profile application that demonstrates professional layout techniques.

```bash
# Create the project
flutter create profile_card_app
cd profile_card_app

# We'll build a comprehensive profile application
```

**🎯 TODO**: Replace `lib/main.dart` with our advanced layout foundation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professional Profile Cards',
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
  int _selectedLayoutType = 0;

  final List<String> _layoutTypes = [
    'Business Cards',
    'Social Profiles', 
    'Team Members',
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
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => _showLayoutInfo(context),
            tooltip: 'Layout Information',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: _layoutTypes.map((type) => Tab(text: type)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const BusinessCardsTab(),
          const SocialProfilesTab(),
          const TeamMembersTab(),
          const ContactCardsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLayoutAnalysis(context),
        icon: const Icon(Icons.analytics_outlined),
        label: const Text('Layout Analysis'),
        tooltip: 'Analyze Layout Patterns',
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
          '• Adaptive UI components',
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
```

**🎯 Key Layout Concepts Introduced**:
- Advanced AppBar with transparent background and custom styling
- TabBar integration with custom indicator and scrollable tabs
- Proper theme integration and Material 3 design
- System UI overlay configuration for professional appearance

### Step 2: Implement Business Cards Layout

**🎯 TODO**: Create the first advanced layout pattern - Business Cards:

```dart
class BusinessCardsTab extends StatelessWidget {
  const BusinessCardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Professional Business Cards',
            'Complex layouts with advanced positioning',
          ),
          const SizedBox(height: 24),
          
          // Grid layout for different card styles
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.8,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
            ),
            itemCount: _businessCardData.length,
            itemBuilder: (context, index) {
              final cardData = _businessCardData[index];
              return BusinessCard(
                name: cardData['name'],
                title: cardData['title'],
                company: cardData['company'],
                email: cardData['email'],
                phone: cardData['phone'],
                website: cardData['website'],
                cardStyle: BusinessCardStyle.values[index % BusinessCardStyle.values.length],
              );
            },
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
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.4,
          ),
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
      'email': 'marcus@designstudio.io',
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

enum BusinessCardStyle {
  modern,
  elegant,
  creative,
  minimal,
}

class BusinessCard extends StatelessWidget {
  final String name;
  final String title;
  final String company;
  final String email;
  final String phone;
  final String website;
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
        return _buildModernCard(context);
      case BusinessCardStyle.elegant:
        return _buildElegantCard(context);
      case BusinessCardStyle.creative:
        return _buildCreativeCard(context);
      case BusinessCardStyle.minimal:
        return _buildMinimalCard(context);
    }
  }

  Widget _buildModernCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
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
          
          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
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
                
                // Name and title
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
                
                const SizedBox(height: 16),
                
                // Contact info
                Row(
                  children: [
                    Expanded(
                      child: _buildContactItem(
                        Icons.email_outlined,
                        email,
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildContactItem(
                        Icons.language,
                        website,
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with logo space
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.business_center_outlined,
                    color: Colors.grey[600],
                    size: 24,
                  ),
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
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const Spacer(),
            
            // Name and title section
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Contact details
            Column(
              children: [
                _buildElegantContactRow(Icons.email_outlined, email),
                const SizedBox(height: 8),
                _buildElegantContactRow(Icons.phone_outlined, phone),
                const SizedBox(height: 8),
                _buildElegantContactRow(Icons.language, website),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreativeCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Animated background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF6B6B),
                    Color(0xFF4ECDC4),
                    Color(0xFF45B7D1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            
            // Geometric patterns
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
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Creative header
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
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
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Main content
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
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
                  
                  const SizedBox(height: 16),
                  
                  // Contact in creative layout
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCreativeContact('EMAIL', email),
                            const SizedBox(height: 8),
                            _buildCreativeContact('WEB', website),
                          ],
                        ),
                      ),
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

  Widget _buildMinimalCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Minimal header
            Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
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
            
            // Main content
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Minimal contact
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  website,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 6),
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

  Widget _buildElegantContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
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
```

### Step 3: Implement Social Profiles Layout

**🎯 TODO**: Create dynamic social media profile layouts:

```dart
class SocialProfilesTab extends StatelessWidget {
  const SocialProfilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Social Media Profiles',
            'Instagram-style layouts with advanced positioning',
          ),
          const SizedBox(height: 24),
          
          // Staggered grid of profile cards
          StaggeredProfileGrid(profiles: _socialProfileData),
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
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
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
    {
      'name': 'David Kim',
      'username': '@davidtech',
      'bio': 'Tech entrepreneur building the future one app at a time',
      'followers': 25000,
      'following': 450,
      'posts': 234,
      'isVerified': true,
      'profileColor': Colors.green,
    },
  ];
}

class StaggeredProfileGrid extends StatelessWidget {
  final List<Map<String, dynamic>> profiles;

  const StaggeredProfileGrid({
    super.key,
    required this.profiles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: profiles.asMap().entries.map((entry) {
        final index = entry.key;
        final profile = entry.value;
        
        return Padding(
          padding: EdgeInsets.only(
            bottom: 20,
            left: index % 2 == 0 ? 0 : 20,
            right: index % 2 == 1 ? 0 : 20,
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

class SocialProfileCard extends StatefulWidget {
  final String name;
  final String username;
  final String bio;
  final int followers;
  final int following;
  final int posts;
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
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.profileColor.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Profile header
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.profileColor,
                                    widget.profileColor.withOpacity(0.7),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.profileColor.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 35,
                              ),
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
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
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
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Bio
                    Text(
                      widget.bio,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF374151),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Stats
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
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
                    
                    const SizedBox(height: 20),
                    
                    // Action buttons
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
                              backgroundColor: _isFollowing 
                                  ? Colors.grey[200] 
                                  : widget.profileColor,
                              foregroundColor: _isFollowing 
                                  ? Colors.grey[700] 
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _isFollowing ? 'Following' : 'Follow',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            child: const Text(
                              'Message',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.grey[300],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
```

### Step 4: Create Layout Analysis Tool

**🎯 TODO**: Add an interactive layout analysis bottom sheet:

```dart
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
      'description': 'How widgets determine their size and position',
      'examples': [
        'Container with fixed width/height',
        'Expanded widgets filling available space',
        'Flexible widgets taking minimum space',
        'Intrinsic dimensions from content',
      ],
    },
    {
      'title': 'Positioning',
      'icon': Icons.control_camera,
      'description': 'Advanced positioning techniques',
      'examples': [
        'Stack with Positioned widgets',
        'Align widget for relative positioning',
        'Transform for rotation and scaling',
        'Padding and Margin for spacing',
      ],
    },
    {
      'title': 'Responsive',
      'icon': Icons.devices,
      'description': 'Adapting to different screen sizes',
      'examples': [
        'MediaQuery for screen dimensions',
        'LayoutBuilder for parent constraints',
        'AspectRatio for proportional sizing',
        'Breakpoints for different devices',
      ],
    },
    {
      'title': 'Performance',
      'icon': Icons.speed,
      'description': 'Optimizing layout performance',
      'examples': [
        'const constructors for static widgets',
        'RepaintBoundary for isolated repainting',
        'ListView.builder for large lists',
        'CustomScrollView for complex scrolling',
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
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Layout Analysis',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Deep dive into Flutter layout concepts',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Analysis type selector
              Container(
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _analysisTypes.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedAnalysisType;
                    final analysisType = _analysisTypes[index];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAnalysisType = index;
                        });
                      },
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Theme.of(context).primaryColor 
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              analysisType['icon'],
                              color: isSelected 
                                  ? Colors.white 
                                  : Colors.grey[600],
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              analysisType['title'],
                              style: TextStyle(
                                color: isSelected 
                                    ? Colors.white 
                                    : Colors.grey[700],
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
              
              // Analysis content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(16),
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
                              const SizedBox(width: 12),
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
                          const SizedBox(height: 12),
                          Text(
                            _analysisTypes[_selectedAnalysisType]['description'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue[800],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    const Text(
                      'Key Concepts:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    ...(_analysisTypes[_selectedAnalysisType]['examples'] as List<String>)
                        .map((example) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(top: 8, right: 12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      example,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
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
```

### Step 5: Add Remaining Tabs (Placeholder Implementation)

**🎯 TODO**: Complete the remaining tabs to demonstrate different layout patterns:

```dart
class TeamMembersTab extends StatelessWidget {
  const TeamMembersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Team Members Layout',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Advanced grid layouts with\ndynamic content sizing',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '🚀 Coming in full implementation!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
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
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contact_phone_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Contact Cards Layout',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Interactive contact layouts with\nanimated interactions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '🚀 Coming in full implementation!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🚀 How to Run

```bash
# Create and run the project
flutter create profile_card_app
cd profile_card_app

# Replace lib/main.dart with the complete workshop code
flutter run
```

## 🎉 Verification Checklist

Confirm your layout mastery:

- [ ] Understand advanced constraint systems and how widgets size themselves
- [ ] Can create complex multi-layered layouts with proper positioning
- [ ] Know how to build responsive designs that adapt to screen sizes
- [ ] Can implement custom spacing systems and design consistency
- [ ] Understand performance implications of different layout choices
- [ ] Can create reusable layout components and design patterns
- [ ] Master Stack positioning with Positioned widgets
- [ ] Implement professional animation and interaction patterns
- [ ] Build complex grid and list layouts efficiently
- [ ] Create adaptive UIs that work across platforms

## 🧠 Key Concepts Mastered

### **Advanced Layout Techniques**
- Complex constraint systems and how widgets negotiate sizes
- Advanced positioning with Stack and Positioned widgets
- Custom spacing systems and design consistency patterns
- Multi-layered UI composition with proper z-indexing

### **Responsive Design Patterns**
- MediaQuery for screen-aware layouts
- LayoutBuilder for parent-constraint awareness
- Breakpoint systems for different device categories
- Adaptive components that scale gracefully

### **Performance Optimization**
- Efficient widget rebuilding strategies
- Proper use of const constructors
- Layout performance best practices
- Memory-efficient list and grid patterns

### **Professional UI Patterns**
- Design system implementation
- Consistent spacing and typography
- Professional animation patterns
- Advanced theming and branding

## 🔄 Next Steps

Ready for [Lesson 06: Navigation & Routing](../lesson_06/) where we'll build multi-screen applications with sophisticated navigation patterns!

## 🎓 What You've Accomplished

You now have:
- ✅ **Advanced layout expertise** - Can create sophisticated, professional UIs
- ✅ **Responsive design skills** - Build adaptive interfaces for any device
- ✅ **Performance awareness** - Optimize layouts for smooth user experiences
- ✅ **Professional patterns** - Use industry-standard layout techniques
- ✅ **Complete reference app** - Your own advanced layout demonstration

**🚀 You're now ready to build production-quality Flutter layouts with confidence!**

---

**🎯 Layout Mastery Achieved**: You understand advanced Flutter layout systems and can compose beautiful, responsive user interfaces that work perfectly across all platforms!