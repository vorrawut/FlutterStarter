# 🛠 Workshop

## 🎯 What We're Building
An interactive **Widget Gallery App** that demonstrates every essential Flutter widget type. This hands-on exploration will teach you widget composition, lifecycle, and best practices through building a comprehensive reference tool.

## ✅ Expected Outcome
By the end of this workshop, you will:
- ✅ Master the difference between StatelessWidget and StatefulWidget
- ✅ Understand the widget tree and BuildContext
- ✅ Use all essential built-in Flutter widgets
- ✅ Create custom, reusable widgets
- ✅ Implement proper widget composition patterns
- ✅ Build a complete widget reference application

## 👨‍💻 Steps to Complete

### Step 1: Project Setup & Understanding Widget Types

Let's start by creating our widget gallery project and understanding the fundamental widget types.

```bash
# Create the project
flutter create widget_gallery_app
cd widget_gallery_app

# We'll replace the default main.dart with our widget exploration app
```

**🎯 TODO**: Replace `lib/main.dart` with our widget gallery foundation:

```dart
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

class _WidgetGalleryHomeState extends State<WidgetGalleryHome> {
  int _selectedIndex = 0;

  // List of widget categories we'll explore
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('🎨 Flutter Widget Gallery'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          for (int i = 0; i < _pageLabels.length; i++)
            BottomNavigationBarItem(
              icon: Icon(_getIconForPage(i)),
              label: _pageLabels[i],
            ),
        ],
      ),
    );
  }

  IconData _getIconForPage(int index) {
    switch (index) {
      case 0: return Icons.widgets;
      case 1: return Icons.view_quilt;
      case 2: return Icons.touch_app;
      case 3: return Icons.build;
      default: return Icons.help;
    }
  }
}

// Placeholder pages - we'll implement these step by step
class BasicWidgetsPage extends StatelessWidget {
  const BasicWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Basic Widgets - Coming Soon!'),
    );
  }
}

class LayoutWidgetsPage extends StatelessWidget {
  const LayoutWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Layout Widgets - Coming Soon!'),
    );
  }
}

class InteractiveWidgetsPage extends StatelessWidget {
  const InteractiveWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Interactive Widgets - Coming Soon!'),
    );
  }
}

class CustomWidgetsPage extends StatelessWidget {
  const CustomWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Custom Widgets - Coming Soon!'),
    );
  }
}
```

**🎯 Key Concepts to Notice**:
- `StatelessWidget` vs `StatefulWidget` - WidgetGalleryApp vs WidgetGalleryHome
- `State` class - Manages mutable data for StatefulWidget
- `setState()` - Triggers widget rebuilds when data changes
- Widget composition - Building complex UI from simple widgets

### Step 2: Implement Basic Widgets Page

**🎯 TODO**: Replace the `BasicWidgetsPage` with comprehensive widget examples:

```dart
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
            'Displays text with various styles',
            _buildTextExamples(),
          ),
          
          _buildSectionTitle('Image Widgets'),
          _buildWidgetCard(
            'Image Widget', 
            'Displays images from various sources',
            _buildImageExamples(),
          ),
          
          _buildSectionTitle('Icon Widgets'),
          _buildWidgetCard(
            'Icon Widget',
            'Material Design and custom icons',
            _buildIconExamples(),
          ),
          
          _buildSectionTitle('Container Widget'),
          _buildWidgetCard(
            'Container Widget',
            'A box model for decorating and positioning',
            _buildContainerExamples(),
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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

  Widget _buildTextExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Default Text'),
        const Text(
          'Styled Text',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          'Colored Background Text',
          style: TextStyle(
            backgroundColor: Colors.yellow[200],
            fontSize: 16,
          ),
        ),
        const Text(
          'This is a longer text that demonstrates text wrapping and how Flutter handles multiple lines of text content automatically.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildImageExamples() {
    return Column(
      children: [
        // Asset image (you'll need to add this to pubspec.yaml and assets folder)
        Container(
          height: 100,
          width: 100,
          color: Colors.grey[300],
          child: const Icon(
            Icons.image,
            size: 50,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Asset Image Placeholder'),
        const SizedBox(height: 16),
        
        // Network image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://picsum.photos/150/100',
            height: 100,
            width: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 100,
                width: 150,
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Text('Network Image'),
      ],
    );
  }

  Widget _buildIconExamples() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildIconExample(Icons.home, 'Home'),
        _buildIconExample(Icons.favorite, 'Favorite', Colors.red),
        _buildIconExample(Icons.star, 'Star', Colors.amber),
        _buildIconExample(Icons.settings, 'Settings', Colors.grey),
        _buildIconExample(Icons.notifications, 'Notifications', Colors.blue),
        _buildIconExample(Icons.shopping_cart, 'Cart', Colors.green),
      ],
    );
  }

  Widget _buildIconExample(IconData icon, String label, [Color? color]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 32,
          color: color ?? Colors.black87,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildContainerExamples() {
    return Column(
      children: [
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
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            
            // Container with decoration
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue],
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
                  'Styled',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Container with border
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
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange),
          ),
          child: const Text(
            'Container with padding, margin, and full width',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
```

### Step 3: Implement Layout Widgets Page

**🎯 TODO**: Replace the `LayoutWidgetsPage` with layout widget demonstrations:

```dart
class LayoutWidgetsPage extends StatelessWidget {
  const LayoutWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Row & Column'),
          _buildWidgetCard(
            'Row Widget',
            'Arranges children horizontally',
            _buildRowExample(),
          ),
          _buildWidgetCard(
            'Column Widget', 
            'Arranges children vertically',
            _buildColumnExample(),
          ),
          
          _buildSectionTitle('Flexible Layouts'),
          _buildWidgetCard(
            'Expanded Widget',
            'Expands children to fill available space',
            _buildExpandedExample(),
          ),
          _buildWidgetCard(
            'Flexible Widget',
            'Allows children to occupy available space flexibly',
            _buildFlexibleExample(),
          ),
          
          _buildSectionTitle('Stack & Positioned'),
          _buildWidgetCard(
            'Stack Widget',
            'Overlays widgets on top of each other',
            _buildStackExample(),
          ),
          
          _buildSectionTitle('Scrollable Widgets'),
          _buildWidgetCard(
            'ListView Widget',
            'Scrollable list of widgets',
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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
        const Text('MainAxisAlignment.spaceEvenly:'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildColoredBox('A', Colors.red),
            _buildColoredBox('B', Colors.green),
            _buildColoredBox('C', Colors.blue),
          ],
        ),
        const SizedBox(height: 16),
        const Text('MainAxisAlignment.center:'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildColoredBox('1', Colors.orange),
            const SizedBox(width: 8),
            _buildColoredBox('2', Colors.purple),
            const SizedBox(width: 8),
            _buildColoredBox('3', Colors.teal),
          ],
        ),
      ],
    );
  }

  Widget _buildColumnExample() {
    return Column(
      children: [
        const Text('CrossAxisAlignment.start:'),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColoredBox('Top', Colors.red),
            const SizedBox(height: 8),
            _buildColoredBox('Middle', Colors.green),
            const SizedBox(height: 8),
            _buildColoredBox('Bottom', Colors.blue),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedExample() {
    return Column(
      children: [
        const Text('Row with Expanded widgets:'),
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
                    child: Text('Flex: 1', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.green,
                  child: const Center(
                    child: Text('Flex: 2', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.blue,
                  child: const Center(
                    child: Text('Flex: 1', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlexibleExample() {
    return Column(
      children: [
        const Text('Row with Flexible widgets:'),
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
                    child: Text('Flexible 1', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              Container(
                width: 100,
                color: Colors.grey,
                child: const Center(
                  child: Text('Fixed', style: TextStyle(color: Colors.white)),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.purple,
                  child: const Center(
                    child: Text('Flexible 2', style: TextStyle(color: Colors.white)),
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
        const Text('Stack with positioned widgets:'),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          width: double.infinity,
          child: Stack(
            children: [
              Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Text('Background'),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  width: 60,
                  height: 40,
                  color: Colors.red,
                  child: const Center(
                    child: Text('Top Left', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  width: 60,
                  height: 40,
                  color: Colors.blue,
                  child: const Center(
                    child: Text('Bottom Right', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
              ),
              const Center(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: Text('Center', style: TextStyle(color: Colors.white)),
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
        const Text('Horizontal ListView:'),
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
                  color: Colors.primaries[index % Colors.primaries.length],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Item $index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColoredBox(String text, Color color) {
    return Container(
      width: 50,
      height: 50,
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
          ),
        ),
      ),
    );
  }
}
```

### Step 4: Implement Interactive Widgets Page

**🎯 TODO**: Create the interactive widgets demonstration:

```dart
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
            'Different button types and states',
            _buildButtonExamples(),
          ),
          
          _buildSectionTitle('Input Widgets'),
          _buildWidgetCard(
            'Text Input',
            'Text fields and form inputs',
            _buildTextFieldExamples(),
          ),
          
          _buildSectionTitle('Selection Widgets'),
          _buildWidgetCard(
            'Switches & Checkboxes',
            'Boolean selection widgets',
            _buildSelectionExamples(),
          ),
          _buildWidgetCard(
            'Sliders & Radio',
            'Value selection widgets',
            _buildValueSelectionExamples(),
          ),
          
          _buildSectionTitle('Gesture Detection'),
          _buildWidgetCard(
            'GestureDetector',
            'Detecting taps, drags, and other gestures',
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          onPressed: () {
            setState(() {
              _buttonTapCount++;
            });
          },
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 8),
        Text('Button tapped $_buttonTapCount times'),
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
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _textController.text.isEmpty 
            ? 'Type something above to see it here!'
            : 'You typed: ${_textController.text}',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildSelectionExamples() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Switch:'),
            Switch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Checkbox:'),
            Checkbox(
              value: _checkboxValue,
              onChanged: (value) {
                setState(() {
                  _checkboxValue = value ?? false;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Checkbox with title'),
          subtitle: const Text('This is a subtitle'),
          value: _checkboxValue,
          onChanged: (value) {
            setState(() {
              _checkboxValue = value ?? false;
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Switch: ${_switchValue ? "ON" : "OFF"}, '
          'Checkbox: ${_checkboxValue ? "CHECKED" : "UNCHECKED"}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildValueSelectionExamples() {
    return Column(
      children: [
        const Text('Slider:'),
        Slider(
          value: _sliderValue,
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
            });
          },
          divisions: 10,
          label: (_sliderValue * 100).round().toString(),
        ),
        Text('Value: ${(_sliderValue * 100).round()}%'),
        
        const SizedBox(height: 24),
        const Text('Radio Buttons:'),
        RadioListTile<String>(
          title: const Text('Option 1'),
          value: 'option1',
          groupValue: _radioValue,
          onChanged: (value) {
            setState(() {
              _radioValue = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Option 2'),
          value: 'option2',
          groupValue: _radioValue,
          onChanged: (value) {
            setState(() {
              _radioValue = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Option 3'),
          value: 'option3',
          groupValue: _radioValue,
          onChanged: (value) {
            setState(() {
              _radioValue = value!;
            });
          },
        ),
        Text(
          'Selected: $_radioValue',
          style: const TextStyle(fontWeight: FontWeight.w500),
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
              const SnackBar(content: Text('Container tapped!')),
            );
          },
          onLongPress: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Container long pressed!')),
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
            ),
            child: const Center(
              child: Text(
                'Tap or Long Press Me!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('InkWell tapped with ripple effect!')),
            );
          },
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'InkWell with Ripple Effect',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

### Step 5: Implement Custom Widgets Page

**🎯 TODO**: Create custom widget examples and best practices:

```dart
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
            'Reusable custom widget for displaying user information',
            Column(
              children: [
                UserProfileCard(
                  name: 'Alice Johnson',
                  email: 'alice@example.com',
                  avatarUrl: 'https://i.pravatar.cc/150?img=1',
                  isOnline: true,
                ),
                const SizedBox(height: 16),
                UserProfileCard(
                  name: 'Bob Smith',
                  email: 'bob@example.com',
                  avatarUrl: 'https://i.pravatar.cc/150?img=2',
                  isOnline: false,
                ),
              ],
            ),
          ),
          
          _buildSectionTitle('Custom Stateful Widgets'),
          _buildWidgetCard(
            'Interactive Counter Card',
            'Custom widget with internal state management',
            Column(
              children: [
                CounterCard(title: 'Likes', initialValue: 42),
                const SizedBox(height: 16),
                CounterCard(title: 'Views', initialValue: 1337, step: 10),
              ],
            ),
          ),
          
          _buildSectionTitle('Composable Widgets'),
          _buildWidgetCard(
            'Feature Showcase Card',
            'Complex widget composed of multiple custom widgets',
            const FeatureShowcaseCard(
              title: 'Premium Features',
              features: [
                'Unlimited Storage',
                'Priority Support',
                'Advanced Analytics',
                'Custom Themes',
              ],
              price: '\$9.99/month',
              isPopular: true,
            ),
          ),
          
          _buildSectionTitle('Widget Best Practices'),
          _buildBestPracticesCard(),
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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
            const Text(
              'Widget Development Best Practices',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildBestPracticeItem(
              '1. Single Responsibility',
              'Each widget should have one clear purpose',
              Icons.check_circle,
              Colors.green,
            ),
            _buildBestPracticeItem(
              '2. Immutable Properties',
              'Use final fields and const constructors when possible',
              Icons.security,
              Colors.blue,
            ),
            _buildBestPracticeItem(
              '3. Composition over Inheritance',
              'Build complex widgets by combining simple ones',
              Icons.layers,
              Colors.orange,
            ),
            _buildBestPracticeItem(
              '4. Extract Reusable Widgets',
              'Break down large build methods into smaller widgets',
              Icons.widgets,
              Colors.purple,
            ),
            _buildBestPracticeItem(
              '5. Minimize Rebuilds',
              'Use const constructors and widget keys appropriately',
              Icons.speed,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestPracticeItem(String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
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

// Custom Widget Examples

class UserProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;
  final bool isOnline;

  const UserProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(avatarUrl),
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: const Icon(Icons.person), // Fallback
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
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
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: isOnline ? Colors.green : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.more_vert,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

class CounterCard extends StatefulWidget {
  final String title;
  final int initialValue;
  final int step;

  const CounterCard({
    super.key,
    required this.title,
    this.initialValue = 0,
    this.step = 1,
  });

  @override
  State<CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<CounterCard> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _count.toString(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _count = (_count - widget.step).clamp(0, double.infinity).toInt();
                    });
                  },
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red[100],
                    foregroundColor: Colors.red,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _count += widget.step;
                    });
                  },
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green[100],
                    foregroundColor: Colors.green,
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

class FeatureShowcaseCard extends StatelessWidget {
  final String title;
  final List<String> features;
  final String price;
  final bool isPopular;

  const FeatureShowcaseCard({
    super.key,
    required this.title,
    required this.features,
    required this.price,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isPopular ? 8 : 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isPopular 
            ? Border.all(color: Colors.orange, width: 2)
            : null,
        ),
        child: Column(
          children: [
            if (isPopular)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Text(
                  'MOST POPULAR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...features.map((feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
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
                          SnackBar(content: Text('Selected $title plan!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPopular ? Colors.orange : null,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Choose Plan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
```

### Step 6: Run and Test Your Widget Gallery

**🎯 TODO**: Test your comprehensive widget gallery:

```bash
# Run the app
flutter run

# Navigate through all four tabs:
# 1. Basic Widgets - Text, Image, Icon, Container examples
# 2. Layout Widgets - Row, Column, Stack, ListView examples  
# 3. Interactive Widgets - Buttons, inputs, selections with live state
# 4. Custom Widgets - Reusable components and best practices
```

### Step 7: Experiment and Extend

**🎯 TODO**: Try these additional challenges:

1. **Add Animation Examples**
   - Create animated containers
   - Add loading spinners
   - Implement hero animations

2. **Build More Custom Widgets**
   - Weather widget with icons
   - Progress indicators
   - Custom navigation components

3. **Implement Widget Testing**
   - Add widget tests for custom components
   - Test interactive widget state changes

## 🚀 How to Run

```bash
# Create and run the project
flutter create widget_gallery_app
cd widget_gallery_app

# Replace lib/main.dart with the complete workshop code
flutter run
```

## 🎉 Verification Checklist

Confirm your widget mastery:

- [ ] Understand the difference between StatelessWidget and StatefulWidget
- [ ] Can use setState() to manage widget state
- [ ] Know how to use essential layout widgets (Row, Column, Stack)
- [ ] Can handle user input with interactive widgets
- [ ] Understand widget composition and nesting
- [ ] Can create custom, reusable widgets
- [ ] Know widget lifecycle and BuildContext usage
- [ ] Can debug widget tree and layout issues
- [ ] Follow widget development best practices
- [ ] Can build complex UIs from simple widget building blocks

## 🧠 Key Concepts Mastered

### **Widget Tree Understanding**
- Every UI element is a widget
- Widgets form a tree structure
- Parent widgets configure child widgets
- BuildContext provides access to widget tree

### **StatelessWidget vs StatefulWidget**
- **StatelessWidget**: Immutable, no internal state
- **StatefulWidget**: Can hold mutable state
- **State lifecycle**: initState, build, setState, dispose

### **Widget Composition**
- Build complex UIs by combining simple widgets
- Extract reusable widgets for code organization
- Use const constructors for performance

### **Layout Widgets**
- **Row/Column**: Linear layouts with flex properties
- **Stack**: Overlapping widgets with positioning
- **Expanded/Flexible**: Control space distribution

### **Interactive Widgets**
- Handle user input through callbacks
- Manage state changes with setState()
- Provide visual feedback for user actions

## 🔄 Next Steps

Ready for [Lesson 05: Layouts & UI Composition](../lesson_05/) where we'll build complex, responsive layouts and create a beautiful profile application!

## 🎓 What You've Accomplished

You now have:
- ✅ **Deep widget understanding** - Know how Flutter UI is constructed
- ✅ **Practical experience** with all essential widget types
- ✅ **Custom widget skills** - Can create reusable components
- ✅ **Interactive development** - Handle user input and state management
- ✅ **Complete reference app** - Your own widget gallery for future use

**🚀 You're now ready to build sophisticated Flutter UIs with confidence!**

---

**🎯 Widget Mastery Achieved**: You understand the fundamental building blocks of Flutter and can compose beautiful, interactive user interfaces!