# 🛠 Workshop

## 🎯 What We're Building
A comprehensive understanding of Dart language fundamentals through hands-on coding exercises. We'll build a "Dart Learning Playground" app that demonstrates every key concept while creating a useful reference tool.

## ✅ Expected Outcome
By the end of this workshop, you will:
- ✅ Master Dart syntax, types, and null safety
- ✅ Understand functions, classes, and object-oriented programming
- ✅ Work confidently with collections and async programming
- ✅ Build a complete Dart reference app
- ✅ Be ready for advanced Flutter concepts

## 👨‍💻 Steps to Complete

### Step 1: Project Setup

Let's create our Dart learning playground project.

```bash
# Create the project
flutter create dart_fundamentals_app
cd dart_fundamentals_app

# Clean up the default app
# We'll replace lib/main.dart with our custom learning app
```

### Step 2: Dart Types and Variables

**🎯 TODO**: Create `lib/models/dart_examples.dart` and explore Dart types:

```dart
// lib/models/dart_examples.dart
class DartExamples {
  // Basic Types
  static void exploreBasicTypes() {
    // Numbers
    int age = 25;
    double height = 5.9;
    num temperature = 36.5; // Can be int or double
    
    // Strings
    String name = 'Flutter Developer';
    String multiLine = '''
      This is a
      multi-line string
    ''';
    
    // Booleans
    bool isLearning = true;
    bool hasExperience = false;
    
    // Lists (Arrays)
    List<String> frameworks = ['Flutter', 'React Native', 'Ionic'];
    var numbers = <int>[1, 2, 3, 4, 5];
    
    // Maps (Dictionaries)
    Map<String, int> scores = {
      'Alice': 95,
      'Bob': 87,
      'Charlie': 92,
    };
    
    // Sets (Unique collections)
    Set<String> skills = {'Dart', 'Flutter', 'Firebase'};
    
    print('Age: $age, Height: $height');
    print('Name: $name');
    print('Frameworks: $frameworks');
    print('Scores: $scores');
    print('Skills: $skills');
  }
}
```

### Step 3: Null Safety Deep Dive

**🎯 TODO**: Add null safety examples:

```dart
class NullSafetyExamples {
  // Nullable vs Non-nullable
  static void exploreNullSafety() {
    // Non-nullable (guaranteed to have a value)
    String definitelyHasValue = 'Hello Flutter';
    
    // Nullable (might be null)
    String? mightBeNull;
    
    // Null-aware operators
    String? nullableString;
    
    // Null-aware access
    int? length = nullableString?.length;
    
    // Null coalescing
    String displayName = nullableString ?? 'Default Name';
    
    // Null assertion (use carefully!)
    // String definite = nullableString!; // Throws if null
    
    // Late variables (initialized later)
    late String lateInitialized;
    lateInitialized = 'Initialized later';
    
    print('Length: $length');
    print('Display Name: $displayName');
    print('Late initialized: $lateInitialized');
  }
  
  // Safe navigation examples
  static String? getUppercaseName(String? name) {
    return name?.toUpperCase();
  }
  
  // Null-aware cascade
  static void configureSettings(Map<String, dynamic>? settings) {
    settings
      ?..['theme'] = 'dark'
      ..['fontSize'] = 16;
  }
}
```

### Step 4: Functions and Methods

**🎯 TODO**: Create comprehensive function examples:

```dart
class FunctionExamples {
  // Basic function
  static String greetUser(String name) {
    return 'Hello, $name!';
  }
  
  // Function with optional parameters
  static String createProfile(String name, {int? age, String? city}) {
    String profile = 'Name: $name';
    if (age != null) profile += ', Age: $age';
    if (city != null) profile += ', City: $city';
    return profile;
  }
  
  // Function with default parameters
  static double calculateArea(double width, [double height = 1.0]) {
    return width * height;
  }
  
  // Function with required named parameters
  static String formatDate({
    required int day,
    required int month,
    required int year,
  }) {
    return '$day/$month/$year';
  }
  
  // Arrow functions (for simple expressions)
  static int square(int x) => x * x;
  static bool isEven(int number) => number % 2 == 0;
  
  // Higher-order functions
  static List<int> processNumbers(
    List<int> numbers,
    int Function(int) processor,
  ) {
    return numbers.map(processor).toList();
  }
  
  // Anonymous functions and closures
  static void demonstrateClosure() {
    var multiplier = 3;
    
    var multiplyByThree = (int x) => x * multiplier;
    
    List<int> numbers = [1, 2, 3, 4, 5];
    var results = numbers.map(multiplyByThree).toList();
    
    print('Results: $results');
  }
}
```

### Step 5: Object-Oriented Programming

**🎯 TODO**: Create a class hierarchy to demonstrate OOP concepts:

```dart
// Abstract base class
abstract class Person {
  final String name;
  final int age;
  
  Person(this.name, this.age);
  
  // Abstract method
  void introduce();
  
  // Concrete method
  void greet() {
    print('Hi, my name is $name');
  }
  
  // Getter
  bool get isAdult => age >= 18;
  
  // Override toString
  @override
  String toString() => 'Person(name: $name, age: $age)';
}

// Concrete implementation
class Developer extends Person {
  final List<String> programmingLanguages;
  final String company;
  
  Developer({
    required String name,
    required int age,
    required this.programmingLanguages,
    required this.company,
  }) : super(name, age);
  
  @override
  void introduce() {
    print('I\'m $name, a developer at $company');
    print('I code in: ${programmingLanguages.join(', ')}');
  }
  
  // Method specific to Developer
  void writeCode(String language) {
    if (programmingLanguages.contains(language)) {
      print('$name is writing $language code...');
    } else {
      print('$name doesn\'t know $language yet');
    }
  }
}

// Mixin for additional capabilities
mixin CanTeach {
  List<String> _students = [];
  
  void addStudent(String studentName) {
    _students.add(studentName);
    print('Added $studentName as a student');
  }
  
  void teachLesson(String topic) {
    print('Teaching $topic to ${_students.length} students');
  }
  
  List<String> get students => List.unmodifiable(_students);
}

// Class using mixin
class Instructor extends Developer with CanTeach {
  final String subject;
  
  Instructor({
    required String name,
    required int age,
    required List<String> programmingLanguages,
    required String company,
    required this.subject,
  }) : super(
    name: name,
    age: age,
    programmingLanguages: programmingLanguages,
    company: company,
  );
  
  @override
  void introduce() {
    super.introduce();
    print('I also teach $subject');
  }
}
```

### Step 6: Collections and Iterables

**🎯 TODO**: Master Dart collections:

```dart
class CollectionExamples {
  static void exploreCollections() {
    // List operations
    List<String> fruits = ['apple', 'banana', 'orange'];
    
    // Adding elements
    fruits.add('mango');
    fruits.addAll(['grape', 'kiwi']);
    fruits.insert(1, 'strawberry');
    
    // List methods
    var uppercaseFruits = fruits.map((fruit) => fruit.toUpperCase()).toList();
    var longFruits = fruits.where((fruit) => fruit.length > 5).toList();
    
    // Map operations
    Map<String, int> inventory = {
      'apples': 50,
      'bananas': 30,
      'oranges': 25,
    };
    
    // Map methods
    inventory.forEach((fruit, count) {
      print('$fruit: $count');
    });
    
    var expensiveFruits = inventory.entries
        .where((entry) => entry.value > 30)
        .map((entry) => entry.key)
        .toList();
    
    // Set operations
    Set<String> colors = {'red', 'green', 'blue'};
    Set<String> primaryColors = {'red', 'blue', 'yellow'};
    
    var intersection = colors.intersection(primaryColors);
    var union = colors.union(primaryColors);
    var difference = colors.difference(primaryColors);
    
    print('Fruits: $fruits');
    print('Uppercase: $uppercaseFruits');
    print('Long fruits: $longFruits');
    print('Expensive fruits: $expensiveFruits');
    print('Color intersection: $intersection');
    print('Color union: $union');
    print('Color difference: $difference');
  }
  
  // Advanced collection operations
  static void advancedOperations() {
    List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    
    // Reduce
    var sum = numbers.reduce((a, b) => a + b);
    
    // Fold
    var product = numbers.fold(1, (acc, num) => acc * num);
    
    // Any and Every
    bool hasEvenNumbers = numbers.any((n) => n % 2 == 0);
    bool allPositive = numbers.every((n) => n > 0);
    
    // Take and Skip
    var firstThree = numbers.take(3).toList();
    var skipFirstThree = numbers.skip(3).toList();
    
    // GroupBy (custom implementation)
    Map<String, List<int>> grouped = {};
    for (var num in numbers) {
      String key = num % 2 == 0 ? 'even' : 'odd';
      grouped.putIfAbsent(key, () => []).add(num);
    }
    
    print('Sum: $sum');
    print('Product: $product');
    print('Has even: $hasEvenNumbers');
    print('All positive: $allPositive');
    print('First three: $firstThree');
    print('Skip first three: $skipFirstThree');
    print('Grouped: $grouped');
  }
}
```

### Step 7: Async Programming

**🎯 TODO**: Master asynchronous programming:

```dart
class AsyncExamples {
  // Future basics
  static Future<String> fetchUserName() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    return 'John Doe';
  }
  
  static Future<Map<String, dynamic>> fetchUserProfile() async {
    await Future.delayed(Duration(seconds: 1));
    return {
      'name': 'John Doe',
      'email': 'john@example.com',
      'age': 30,
    };
  }
  
  // Error handling with async/await
  static Future<String> fetchDataWithErrorHandling() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      // Simulate random error
      if (DateTime.now().millisecond % 2 == 0) {
        throw Exception('Random network error');
      }
      return 'Success: Data fetched';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
  
  // Multiple futures
  static Future<Map<String, dynamic>> fetchCompleteProfile() async {
    // Sequential execution
    String name = await fetchUserName();
    Map<String, dynamic> profile = await fetchUserProfile();
    
    return {
      'fetchedName': name,
      'profile': profile,
    };
  }
  
  // Parallel execution
  static Future<Map<String, dynamic>> fetchProfileInParallel() async {
    // Both futures run simultaneously
    var futures = await Future.wait([
      fetchUserName(),
      fetchUserProfile(),
    ]);
    
    return {
      'name': futures[0],
      'profile': futures[1],
    };
  }
  
  // Stream basics
  static Stream<int> countStream() async* {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }
  
  // Stream transformation
  static Stream<String> processedCountStream() {
    return countStream()
        .map((count) => 'Count: $count')
        .where((text) => !text.contains('3')); // Skip count 3
  }
  
  // Listening to streams
  static Future<void> demonstrateStreams() async {
    print('Starting stream demo...');
    
    await for (String message in processedCountStream()) {
      print(message);
    }
    
    print('Stream demo completed!');
  }
}
```

### Step 8: Create the Main App

**🎯 TODO**: Replace `lib/main.dart` with our learning playground:

```dart
import 'package:flutter/material.dart';
import 'models/dart_examples.dart';

void main() {
  runApp(const DartFundamentalsApp());
}

class DartFundamentalsApp extends StatelessWidget {
  const DartFundamentalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Fundamentals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DartPlaygroundScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DartPlaygroundScreen extends StatefulWidget {
  const DartPlaygroundScreen({super.key});

  @override
  State<DartPlaygroundScreen> createState() => _DartPlaygroundScreenState();
}

class _DartPlaygroundScreenState extends State<DartPlaygroundScreen> {
  String _output = 'Welcome to Dart Fundamentals!\nTap a button to run examples.';
  
  void _runExample(String title, Function example) {
    setState(() {
      _output = 'Running: $title\n' + '=' * 30 + '\n';
    });
    
    // Capture print output
    List<String> prints = [];
    
    // Override print temporarily
    void Function(Object?) originalPrint = print;
    print = (Object? object) {
      prints.add(object.toString());
    };
    
    try {
      example();
    } catch (e) {
      prints.add('Error: $e');
    }
    
    // Restore original print
    print = originalPrint;
    
    setState(() {
      _output += prints.join('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('🎯 Dart Fundamentals Playground'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Example buttons
          Expanded(
            flex: 1,
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.5,
              children: [
                _buildExampleButton(
                  'Basic Types',
                  Icons.text_fields,
                  () => DartExamples.exploreBasicTypes(),
                ),
                _buildExampleButton(
                  'Null Safety',
                  Icons.security,
                  () => NullSafetyExamples.exploreNullSafety(),
                ),
                _buildExampleButton(
                  'Functions',
                  Icons.functions,
                  () => _runFunctionExamples(),
                ),
                _buildExampleButton(
                  'Classes & OOP',
                  Icons.class_,
                  () => _runOOPExamples(),
                ),
                _buildExampleButton(
                  'Collections',
                  Icons.list,
                  () => CollectionExamples.exploreCollections(),
                ),
                _buildExampleButton(
                  'Async/Await',
                  Icons.schedule,
                  () => _runAsyncExamples(),
                ),
              ],
            ),
          ),
          
          // Output area
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _output = 'Output cleared. Ready for next example!';
          });
        },
        tooltip: 'Clear Output',
        child: const Icon(Icons.clear),
      ),
    );
  }
  
  Widget _buildExampleButton(String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: () => _runExample(title, onPressed),
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
      ),
    );
  }
  
  void _runFunctionExamples() {
    print(FunctionExamples.greetUser('Flutter Developer'));
    print(FunctionExamples.createProfile('Alice', age: 25, city: 'New York'));
    print('Area: ${FunctionExamples.calculateArea(5.0, 3.0)}');
    print(FunctionExamples.formatDate(day: 15, month: 6, year: 2024));
    print('Square of 7: ${FunctionExamples.square(7)}');
    
    var doubled = FunctionExamples.processNumbers([1, 2, 3], (x) => x * 2);
    print('Doubled: $doubled');
    
    FunctionExamples.demonstrateClosure();
  }
  
  void _runOOPExamples() {
    var developer = Developer(
      name: 'Sarah',
      age: 28,
      programmingLanguages: ['Dart', 'Flutter', 'JavaScript'],
      company: 'Tech Corp',
    );
    
    developer.introduce();
    developer.writeCode('Dart');
    print('Is adult: ${developer.isAdult}');
    
    var instructor = Instructor(
      name: 'Mike',
      age: 35,
      programmingLanguages: ['Dart', 'Flutter', 'Python'],
      company: 'Code Academy',
      subject: 'Mobile Development',
    );
    
    instructor.introduce();
    instructor.addStudent('Alice');
    instructor.addStudent('Bob');
    instructor.teachLesson('Flutter Basics');
  }
  
  void _runAsyncExamples() async {
    print('Fetching user name...');
    String name = await AsyncExamples.fetchUserName();
    print('User name: $name');
    
    print('\nTesting error handling...');
    String result = await AsyncExamples.fetchDataWithErrorHandling();
    print(result);
    
    print('\nDemonstrating streams...');
    await AsyncExamples.demonstrateStreams();
  }
}
```

### Step 9: Run and Test Your App

**🎯 TODO**: Test your Dart fundamentals app:

```bash
# Run the app
flutter run

# Try each example button and observe the output
# Experiment with the code by modifying examples
# Clear output between runs using the floating action button
```

### Step 10: Experiment and Extend

**🎯 TODO**: Try these additional challenges:

1. **Add Error Handling Examples**
   - Try-catch blocks
   - Custom exceptions
   - Error propagation

2. **Explore Advanced Features**
   - Extension methods
   - Generic types
   - Typedef declarations

3. **Create Interactive Examples**
   - User input fields
   - Dynamic example generation
   - Real-time code evaluation

## 🚀 How to Run

```bash
# Create and run the project
flutter create dart_fundamentals_app
cd dart_fundamentals_app

# Replace lib/main.dart with the workshop code
# Create lib/models/dart_examples.dart with all example classes

flutter run
```

## 🎉 Verification Checklist

Confirm your Dart knowledge:

- [ ] Can declare and use all basic Dart types
- [ ] Understand null safety and nullable types
- [ ] Can write functions with various parameter types
- [ ] Understand classes, inheritance, and mixins
- [ ] Can work with collections (List, Map, Set)
- [ ] Understand async/await and Futures
- [ ] Can work with Streams
- [ ] Know how to handle errors properly
- [ ] Understand object-oriented programming concepts
- [ ] Can read and write idiomatic Dart code

## 🧠 Key Concepts Mastered

### **Type System**
- **Null Safety**: Variables are non-nullable by default
- **Type Inference**: Dart can infer types automatically
- **Sound Type System**: Prevents runtime type errors

### **Functions**
- **First-class**: Functions are objects that can be assigned and passed
- **Optional Parameters**: Named and positional optional parameters
- **Arrow Functions**: Concise syntax for simple functions

### **Object-Oriented Programming**
- **Classes**: Blueprint for creating objects
- **Inheritance**: Code reuse through extending classes
- **Mixins**: Multiple inheritance-like capability
- **Abstract Classes**: Define contracts for subclasses

### **Asynchronous Programming**
- **Futures**: Represent values that will be available later
- **async/await**: Clean syntax for asynchronous code
- **Streams**: Sequences of asynchronous events

## 🔄 Next Steps

Ready for [Lesson 04: Widgets 101](../lesson_04/) where we'll apply your Dart knowledge to build Flutter UIs!

## 🎓 What You've Accomplished

You now have:
- ✅ **Solid Dart foundation** for Flutter development
- ✅ **Hands-on experience** with all key language features
- ✅ **Working playground app** for future reference
- ✅ **Confidence** to tackle Flutter-specific concepts

**🚀 You're now fluent in Dart and ready to build amazing Flutter apps!**

---

**🎯 Dart Mastery Achieved**: You've built a solid foundation in Dart programming that will serve you throughout your Flutter journey!