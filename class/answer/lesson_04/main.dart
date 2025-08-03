import 'package:flutter/material.dart';

void main() {
  runApp(const WidgetGalleryApp());
}

class WidgetGalleryApp extends StatelessWidget {
  const WidgetGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widget Gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const WidgetGalleryHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WidgetGalleryHome extends StatefulWidget {
  const WidgetGalleryHome({super.key});

  @override
  State<WidgetGalleryHome> createState() => _WidgetGalleryHomeState();
}

class _WidgetGalleryHomeState extends State<WidgetGalleryHome>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  final List<Widget> _pages = [
    const BasicWidgetsPage(),
    const LayoutWidgetsPage(),
    const InteractiveWidgetsPage(),
    const CustomWidgetsPage(),
  ];

  final List<String> _pageLabels = [
    'Basic Widgets',
    'Layout Widgets',
    'Interactive Widgets',
    'Custom Widgets',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pageLabels.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('🎨 Flutter Widget Gallery'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: [
            for (int i = 0; i < _pageLabels.length; i++)
              Tab(
                icon: Icon(_getIconForPage(i)),
                text: _pageLabels[i],
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'About Widget Gallery',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickReference(context),
        icon: const Icon(Icons.help_outline),
        label: const Text('Quick Reference'),
        tooltip: 'Show quick widget reference',
      ),
    );
  }

  IconData _getIconForPage(int index) {
    switch (index) {
      case 0:
        return Icons.widgets;
      case 1:
        return Icons.view_quilt;
      case 2:
        return Icons.touch_app;
      case 3:
        return Icons.build;
      default:
        return Icons.help;
    }
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎨 Widget Gallery'),
        content: const Text(
          'This app demonstrates the fundamental Flutter widgets and how to compose them to build beautiful UIs.\n\n'
          'Explore each tab to learn about different widget categories and see them in action!',
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

  void _showQuickReference(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Widget Quick Reference',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: const [
                    QuickReferenceCard(
                      title: 'Layout Widgets',
                      widgets: [
                        'Row - Horizontal layout',
                        'Column - Vertical layout',
                        'Stack - Overlapping widgets',
                        'Container - Box model widget',
                        'Expanded - Fill available space',
                      ],
                    ),
                    QuickReferenceCard(
                      title: 'Interactive Widgets',
                      widgets: [
                        'ElevatedButton - Primary actions',
                        'TextField - Text input',
                        'Switch - Boolean toggle',
                        'Slider - Value selection',
                        'GestureDetector - Custom gestures',
                      ],
                    ),
                    QuickReferenceCard(
                      title: 'Display Widgets',
                      widgets: [
                        'Text - Display text',
                        'Image - Display images',
                        'Icon - Material icons',
                        'Card - Material card',
                        'ListTile - List item',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Basic Widgets Page with Enhanced Examples
class BasicWidgetsPage extends StatelessWidget {
  const BasicWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Text Widgets'),
          _buildWidgetCard(
            'Text Widget',
            'Displays text with various styles and formatting options',
            _buildEnhancedTextExamples(),
          ),
          _buildSectionTitle('Image Widgets'),
          _buildWidgetCard(
            'Image Widget',
            'Displays images from various sources with different fit modes',
            _buildEnhancedImageExamples(),
          ),
          _buildSectionTitle('Icon Widgets'),
          _buildWidgetCard(
            'Icon Widget',
            'Material Design icons with customization options',
            _buildEnhancedIconExamples(),
          ),
          _buildSectionTitle('Container Widget'),
          _buildWidgetCard(
            'Container Widget',
            'A versatile widget for decoration, sizing, and positioning',
            _buildEnhancedContainerExamples(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildWidgetCard(String title, String description, Widget example) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.code,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: example,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTextExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Text Styling Examples',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text('Default Text'),
        const Text(
          'Bold Text',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text(
          'Italic Text',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        Text(
          'Colored Text',
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Text with Background',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const Text(
          'This is a longer text example that demonstrates how Flutter handles text wrapping and line breaks automatically when the text exceeds the available width.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        const Text(
          'Overflow handling with ellipsis...',
          style: TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildEnhancedImageExamples() {
    return Column(
      children: [
        const Text(
          'Image Sources & Fit Modes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://picsum.photos/100/80',
                    height: 80,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        width: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 4),
                const Text('cover', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 80,
                    width: 100,
                    color: Colors.grey[200],
                    child: Image.network(
                      'https://picsum.photos/50/100',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text('contain', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 80,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('asset', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        const Text('CircleAvatar for profile images'),
      ],
    );
  }

  Widget _buildEnhancedIconExamples() {
    return Column(
      children: [
        const Text(
          'Icon Variations',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildIconExample(Icons.home, 'Home', Colors.blue),
            _buildIconExample(Icons.favorite, 'Favorite', Colors.red),
            _buildIconExample(Icons.star, 'Star', Colors.amber),
            _buildIconExample(Icons.settings, 'Settings', Colors.grey),
            _buildIconExample(Icons.notifications, 'Notifications', Colors.orange),
            _buildIconExample(Icons.shopping_cart, 'Cart', Colors.green),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.thumb_up),
              color: Colors.blue,
              iconSize: 32,
            ),
            IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
            IconButton.outlined(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('IconButton variations'),
      ],
    );
  }

  Widget _buildIconExample(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 32,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildEnhancedContainerExamples() {
    return Column(
      children: [
        const Text(
          'Container Decoration Examples',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Basic container
            Container(
              width: 80,
              height: 80,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  'Basic',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            // Gradient container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Gradient',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            // Border container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.red,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: Text(
                  'Border',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[100]!, Colors.orange[50]!],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange),
          ),
          child: const Text(
            'Full-width container with padding, margin, and gradient background',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// Layout Widgets Page (same as before but with small enhancements)
class LayoutWidgetsPage extends StatelessWidget {
  const LayoutWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Linear Layouts'),
          _buildWidgetCard(
            'Row Widget',
            'Arranges children horizontally with various alignment options',
            _buildRowExample(),
          ),
          _buildWidgetCard(
            'Column Widget',
            'Arranges children vertically with flexible spacing',
            _buildColumnExample(),
          ),
          _buildSectionTitle('Flexible Layouts'),
          _buildWidgetCard(
            'Expanded Widget',
            'Expands children to fill available space with flex ratios',
            _buildExpandedExample(),
          ),
          _buildWidgetCard(
            'Flexible Widget',
            'Allows children to occupy available space flexibly',
            _buildFlexibleExample(),
          ),
          _buildSectionTitle('Overlapping Layouts'),
          _buildWidgetCard(
            'Stack Widget',
            'Overlays widgets with absolute and relative positioning',
            _buildStackExample(),
          ),
          _buildSectionTitle('Scrollable Layouts'),
          _buildWidgetCard(
            'ListView Widget',
            'Scrollable list with efficient rendering for large datasets',
            _buildListViewExample(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildWidgetCard(String title, String description, Widget example) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.view_quilt,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: example,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowExample() {
    return Column(
      children: [
        const Text(
          'MainAxisAlignment Examples:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildRowWithLabel('spaceEvenly', MainAxisAlignment.spaceEvenly),
        const SizedBox(height: 8),
        _buildRowWithLabel('spaceBetween', MainAxisAlignment.spaceBetween),
        const SizedBox(height: 8),
        _buildRowWithLabel('center', MainAxisAlignment.center),
        const SizedBox(height: 8),
        _buildRowWithLabel('start', MainAxisAlignment.start),
      ],
    );
  }

  Widget _buildRowWithLabel(String label, MainAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: alignment,
            children: [
              _buildColoredBox('A', Colors.red),
              _buildColoredBox('B', Colors.green),
              _buildColoredBox('C', Colors.blue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColumnExample() {
    return Column(
      children: [
        const Text(
          'CrossAxisAlignment Examples:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildColumnWithLabel('start', CrossAxisAlignment.start),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildColumnWithLabel('center', CrossAxisAlignment.center),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildColumnWithLabel('end', CrossAxisAlignment.end),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColumnWithLabel(String label, CrossAxisAlignment alignment) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: alignment,
            children: [
              _buildColoredBox('1', Colors.red),
              _buildColoredBox('2', Colors.green),
              _buildColoredBox('3', Colors.blue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedExample() {
    return Column(
      children: [
        const Text(
          'Flex Distribution:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.red,
                  child: const Center(
                    child: Text(
                      'flex: 1',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.green,
                  child: const Center(
                    child: Text(
                      'flex: 2',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'flex: 1',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Total ratio: 1:2:1 (25% : 50% : 25%)',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildFlexibleExample() {
    return Column(
      children: [
        const Text(
          'Flexible vs Fixed:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  color: Colors.orange,
                  child: const Center(
                    child: Text(
                      'Flexible',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                color: Colors.grey,
                child: const Center(
                  child: Text(
                    'Fixed 100px',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.purple,
                  child: const Center(
                    child: Text(
                      'Flexible 2x',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStackExample() {
    return Column(
      children: [
        const Text(
          'Layered Positioning:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          width: double.infinity,
          child: Stack(
            children: [
              Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Text('Background Layer'),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Top Left',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Bottom Right',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
              const Center(
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.green,
                  child: Text(
                    'Center',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListViewExample() {
    return Column(
      children: [
        const Text(
          'Horizontal Scrolling List:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.primaries[index % Colors.primaries.length],
                      Colors.primaries[index % Colors.primaries.length]
                          .withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIconForIndex(index),
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Item $index',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getIconForIndex(int index) {
    final icons = [
      Icons.home,
      Icons.star,
      Icons.favorite,
      Icons.settings,
      Icons.person,
      Icons.notifications,
      Icons.shopping_cart,
      Icons.camera,
      Icons.music_note,
      Icons.games,
    ];
    return icons[index % icons.length];
  }

  Widget _buildColoredBox(String text, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// Interactive Widgets Page (same implementation as in workshop)
class InteractiveWidgetsPage extends StatefulWidget {
  const InteractiveWidgetsPage({super.key});

  @override
  State<InteractiveWidgetsPage> createState() => _InteractiveWidgetsPageState();
}

class _InteractiveWidgetsPageState extends State<InteractiveWidgetsPage> {
  // State variables for interactive examples
  bool _switchValue = false;
  bool _checkboxValue = false;
  double _sliderValue = 0.5;
  String _radioValue = 'option1';
  final TextEditingController _textController = TextEditingController();
  int _buttonTapCount = 0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Button Widgets'),
          _buildWidgetCard(
            'Button Variants',
            'Different button types and states with interaction feedback',
            _buildButtonExamples(),
          ),
          _buildSectionTitle('Input Widgets'),
          _buildWidgetCard(
            'Text Input',
            'Text fields and form inputs with validation and formatting',
            _buildTextFieldExamples(),
          ),
          _buildSectionTitle('Selection Widgets'),
          _buildWidgetCard(
            'Switches & Checkboxes',
            'Boolean selection widgets with state management',
            _buildSelectionExamples(),
          ),
          _buildWidgetCard(
            'Sliders & Radio',
            'Value selection widgets with dynamic feedback',
            _buildValueSelectionExamples(),
          ),
          _buildSectionTitle('Gesture Detection'),
          _buildWidgetCard(
            'GestureDetector',
            'Detecting taps, drags, and other touch gestures',
            _buildGestureExamples(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildWidgetCard(String title, String description, Widget example) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.touch_app,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: example,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonExamples() {
    return Column(
      children: [
        const Text(
          'Button Types:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _buttonTapCount++;
                });
              },
              child: const Text('Elevated'),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _buttonTapCount++;
                });
              },
              child: const Text('Outlined'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _buttonTapCount++;
                });
              },
              child: const Text('Text'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _buttonTapCount++;
                });
              },
              child: const Text('Filled'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _buttonTapCount++;
                });
              },
              icon: const Icon(Icons.favorite),
              label: const Text('With Icon'),
            ),
            const ElevatedButton(
              onPressed: null, // Disabled button
              child: Text('Disabled'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: "fab1",
          onPressed: () {
            setState(() {
              _buttonTapCount++;
            });
          },
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Buttons tapped $_buttonTapCount times',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldExamples() {
    return Column(
      children: [
        TextField(
          controller: _textController,
          decoration: const InputDecoration(
            labelText: 'Enter your name',
            hintText: 'John Doe',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          onChanged: (value) {
            setState(() {}); // Rebuild to show current text
          },
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'user@example.com',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
            suffixIcon: Icon(Icons.visibility),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        const TextField(
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description',
            hintText: 'Enter a longer description...',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _textController.text.isEmpty ? Colors.grey[100] : Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _textController.text.isEmpty ? Colors.grey[300]! : Colors.green,
            ),
          ),
          child: Text(
            _textController.text.isEmpty
                ? 'Type something above to see it here!'
                : 'You typed: ${_textController.text}',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: _textController.text.isEmpty ? Colors.grey[600] : Colors.green[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionExamples() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Enable Notifications'),
          subtitle: const Text('Receive push notifications'),
          value: _switchValue,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
            });
          },
        ),
        const Divider(),
        CheckboxListTile(
          title: const Text('I agree to the terms'),
          subtitle: const Text('Please read our terms and conditions'),
          value: _checkboxValue,
          onChanged: (value) {
            setState(() {
              _checkboxValue = value ?? false;
            });
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                'Current State:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Notifications: ${_switchValue ? "Enabled ✅" : "Disabled ❌"}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Terms Accepted: ${_checkboxValue ? "Yes ✅" : "No ❌"}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildValueSelectionExamples() {
    return Column(
      children: [
        const Text(
          'Slider Control:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Slider(
          value: _sliderValue,
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
            });
          },
          divisions: 20,
          label: '${(_sliderValue * 100).round()}%',
        ),
        Text(
          'Value: ${(_sliderValue * 100).round()}%',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),
        const Text(
          'Radio Button Selection:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        RadioListTile<String>(
          title: const Text('🌅 Morning Person'),
          subtitle: const Text('I prefer working in the morning'),
          value: 'option1',
          groupValue: _radioValue,
          onChanged: (value) {
            setState(() {
              _radioValue = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('🦉 Night Owl'),
          subtitle: const Text('I prefer working at night'),
          value: 'option2',
          groupValue: _radioValue,
          onChanged: (value) {
            setState(() {
              _radioValue = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('🌍 Flexible'),
          subtitle: const Text('I can work at any time'),
          value: 'option3',
          groupValue: _radioValue,
          onChanged: (value) {
            setState(() {
              _radioValue = value!;
            });
          },
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Selected preference: $_radioValue',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.orange[700],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildGestureExamples() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Container tapped! 👆')),
            );
          },
          onLongPress: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Container long pressed! ⏰')),
            );
          },
          onDoubleTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Container double tapped! 👆👆')),
            );
          },
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.blue],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Interactive Container',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap, Long Press, or Double Tap!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('InkWell tapped with ripple! 🌊')),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'InkWell with Material Ripple Effect',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Widgets Page (enhanced implementation)
class CustomWidgetsPage extends StatelessWidget {
  const CustomWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Custom Stateless Widgets'),
          _buildWidgetCard(
            'User Profile Card',
            'Reusable custom widget for displaying user information with enhanced styling',
            Column(
              children: [
                UserProfileCard(
                  name: 'Alice Johnson',
                  role: 'Senior Flutter Developer',
                  email: 'alice@flutter.dev',
                  avatarUrl: 'https://i.pravatar.cc/150?img=1',
                  isOnline: true,
                  onTap: () => _showProfileDialog(context, 'Alice Johnson'),
                ),
                const SizedBox(height: 16),
                UserProfileCard(
                  name: 'Bob Smith',
                  role: 'UI/UX Designer',
                  email: 'bob@design.co',
                  avatarUrl: 'https://i.pravatar.cc/150?img=2',
                  isOnline: false,
                  onTap: () => _showProfileDialog(context, 'Bob Smith'),
                ),
              ],
            ),
          ),
          _buildSectionTitle('Custom Stateful Widgets'),
          _buildWidgetCard(
            'Interactive Counter Card',
            'Custom widget with internal state management and animations',
            Column(
              children: [
                CounterCard(title: 'Likes', initialValue: 42, icon: Icons.favorite),
                const SizedBox(height: 16),
                CounterCard(
                  title: 'Views',
                  initialValue: 1337,
                  step: 10,
                  icon: Icons.visibility,
                ),
              ],
            ),
          ),
          _buildSectionTitle('Composable Widgets'),
          _buildWidgetCard(
            'Feature Showcase Card',
            'Complex widget composed of multiple custom widgets with enhanced interactions',
            const FeatureShowcaseCard(
              title: 'Premium Features',
              features: [
                'Unlimited Cloud Storage',
                '24/7 Priority Support',
                'Advanced Analytics Dashboard',
                'Custom Themes & Branding',
                'API Access & Integrations',
              ],
              price: '\$9.99/month',
              originalPrice: '\$19.99',
              isPopular: true,
            ),
          ),
          _buildSectionTitle('Widget Best Practices'),
          _buildBestPracticesCard(),
        ],
      ),
    );
  }

  static void _showProfileDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile: $name'),
        content: Text('This would open $name\'s detailed profile page.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildWidgetCard(String title, String description, Widget example) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.build,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: example,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestPracticesCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, size: 20, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Widget Development Best Practices',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBestPracticeItem(
              '1. Single Responsibility Principle',
              'Each widget should have one clear, focused purpose',
              Icons.check_circle,
              Colors.green,
            ),
            _buildBestPracticeItem(
              '2. Immutable Properties with const',
              'Use final fields and const constructors for performance',
              Icons.security,
              Colors.blue,
            ),
            _buildBestPracticeItem(
              '3. Composition over Inheritance',
              'Build complex widgets by combining simple, reusable ones',
              Icons.layers,
              Colors.orange,
            ),
            _buildBestPracticeItem(
              '4. Extract and Reuse Widgets',
              'Break down large build methods into smaller, focused widgets',
              Icons.widgets,
              Colors.purple,
            ),
            _buildBestPracticeItem(
              '5. Optimize for Performance',
              'Use const constructors, keys, and minimize unnecessary rebuilds',
              Icons.speed,
              Colors.red,
            ),
            _buildBestPracticeItem(
              '6. Test Your Widgets',
              'Write widget tests to ensure reliability and catch regressions',
              Icons.bug_report,
              Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestPracticeItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced Custom Widget Examples

class UserProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final String avatarUrl;
  final bool isOnline;
  final VoidCallback? onTap;

  const UserProfileCard({
    super.key,
    required this.name,
    required this.role,
    required this.email,
    required this.avatarUrl,
    required this.isOnline,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(avatarUrl),
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: const Icon(Icons.person, size: 30),
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
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
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: isOnline ? Colors.green[700] : Colors.grey[600],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CounterCard extends StatefulWidget {
  final String title;
  final int initialValue;
  final int step;
  final IconData icon;

  const CounterCard({
    super.key,
    required this.title,
    this.initialValue = 0,
    this.step = 1,
    this.icon = Icons.add,
  });

  @override
  State<CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<CounterCard>
    with SingleTickerProviderStateMixin {
  late int _count;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _count = widget.initialValue;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
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

  void _animateAndUpdate(VoidCallback update) {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _count.toString(),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.small(
                  heroTag: "${widget.title}_minus",
                  onPressed: _count > 0
                      ? () {
                          _animateAndUpdate(() {
                            setState(() {
                              _count = (_count - widget.step).clamp(0, double.infinity).toInt();
                            });
                          });
                        }
                      : null,
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.red,
                  child: const Icon(Icons.remove),
                ),
                FloatingActionButton.small(
                  heroTag: "${widget.title}_plus",
                  onPressed: () {
                    _animateAndUpdate(() {
                      setState(() {
                        _count += widget.step;
                      });
                    });
                  },
                  backgroundColor: Colors.green[100],
                  foregroundColor: Colors.green,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureShowcaseCard extends StatelessWidget {
  final String title;
  final List<String> features;
  final String price;
  final String? originalPrice;
  final bool isPopular;

  const FeatureShowcaseCard({
    super.key,
    required this.title,
    required this.features,
    required this.price,
    this.originalPrice,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isPopular ? 8 : 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isPopular ? Border.all(color: Colors.orange, width: 2) : null,
        ),
        child: Column(
          children: [
            if (isPopular)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'MOST POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.star, color: Colors.white, size: 16),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      if (originalPrice != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          originalPrice!,
                          style: const TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (originalPrice != null)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '50% OFF',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  ...features.map((feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feature,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected $title plan! 🎉'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPopular ? Colors.orange : null,
                        foregroundColor: isPopular ? Colors.white : null,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: isPopular ? 4 : 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Choose Plan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isPopular ? Icons.star : Icons.arrow_forward,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Quick Reference Card Widget
class QuickReferenceCard extends StatelessWidget {
  final String title;
  final List<String> widgets;

  const QuickReferenceCard({
    super.key,
    required this.title,
    required this.widgets,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...widgets.map((widget) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.widgets, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}