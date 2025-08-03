# 🛠 Workshop 03: Dart Fundamentals Playground

## 🎯 Welcome to Dart Mastery!

This workshop will teach you the Dart programming language through building an interactive **Dart Fundamentals Playground** app. You'll master every essential Dart concept while creating a useful reference tool.

## 📋 Prerequisites
- Completion of Lessons 1-2 (Flutter basics and environment setup)
- Basic programming knowledge in any language
- Understanding of variables, functions, and classes

## 🚀 Getting Started

### Step 1: Create Your Project
```bash
# Navigate to the workshop directory
cd class/workshop/lesson_03

# Create a new Flutter project
flutter create dart_fundamentals_playground
cd dart_fundamentals_playground

# Open in your editor
code . # For VS Code
```

### Step 2: Project Structure Setup

We'll organize our code with a clear structure:

```
lib/
├── main.dart                 # App entry point (you'll modify this)
├── models/
│   └── dart_examples.dart    # Example classes (you'll create this)
├── screens/
│   └── playground_screen.dart # Main playground UI (you'll create this)
└── widgets/
    └── example_card.dart     # Reusable UI components (you'll create this)
```

**🎯 TODO**: Create the directory structure above.

### Step 3: Complete the Workshop Tasks

Follow the comprehensive workshop guide: [workshop_03.md](../../modules/lesson_03/workshop_03.md)

Build your Dart playground app step by step:

#### **🎨 What You'll Build**
- **Interactive Dart Examples** - Run code and see immediate results
- **Basic Types Explorer** - Understand variables, strings, numbers
- **Null Safety Demonstration** - Master Dart's null safety features
- **Function Laboratory** - Experiment with different function types
- **OOP Playground** - Build classes, inheritance, and mixins
- **Collections Workshop** - Work with Lists, Maps, and Sets
- **Async Programming** - Learn Futures, Streams, and async/await

#### **🧠 Core Concepts You'll Master**
- Dart type system and null safety
- Functions and higher-order functions
- Object-oriented programming principles
- Collections and iterables
- Asynchronous programming patterns
- Error handling strategies

### Step 4: Hands-On Exercises

#### **Beginner Challenges**
1. **Variable Playground**
   - Declare variables of different types
   - Experiment with null safety operators
   - Practice string interpolation

2. **Function Workshop**
   - Create functions with different parameter types
   - Build higher-order functions
   - Use arrow function syntax

#### **Intermediate Challenges**
3. **Class Builder**
   - Design custom classes with properties and methods
   - Implement inheritance and mixins
   - Create abstract classes and interfaces

4. **Collection Master**
   - Transform data using map, where, and reduce
   - Work with nested collections
   - Implement custom collection operations

#### **Advanced Challenges**
5. **Async Expert**
   - Build custom Future and Stream operations
   - Handle complex async scenarios
   - Implement proper error handling

6. **Type System Ninja**
   - Work with generics and type parameters
   - Understand covariance and contravariance
   - Use advanced type features

### Step 5: Compare with Solution

After completing the workshop, explore the complete implementation in [answer/lesson_03/](../../answer/lesson_03/) to see:
- Professional Dart code patterns
- Advanced language features
- Performance optimizations
- Best practices implementation

## 🎓 Learning Objectives

By the end of this workshop, you should be able to:

### **Master Dart Syntax**
- [ ] Declare and use all Dart data types
- [ ] Understand and apply null safety features
- [ ] Write functions with various parameter patterns
- [ ] Use string interpolation and manipulation

### **Object-Oriented Programming**
- [ ] Design and implement custom classes
- [ ] Use inheritance and composition effectively
- [ ] Implement and use mixins
- [ ] Understand abstract classes and interfaces

### **Collections and Data**
- [ ] Work with Lists, Maps, and Sets efficiently
- [ ] Transform data using functional programming
- [ ] Handle nested and complex data structures
- [ ] Implement custom data operations

### **Asynchronous Programming**
- [ ] Understand and use Futures and async/await
- [ ] Work with Streams for reactive programming
- [ ] Handle errors in async operations
- [ ] Implement complex async patterns

### **Advanced Features**
- [ ] Use generics for type-safe code
- [ ] Implement extension methods
- [ ] Understand typedef and function types
- [ ] Work with advanced language features

## 🔧 Starter Code Templates

### **Main App Structure**
```dart
// lib/main.dart - STARTER TEMPLATE
import 'package:flutter/material.dart';

void main() {
  runApp(const DartPlaygroundApp());
}

class DartPlaygroundApp extends StatelessWidget {
  const DartPlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Fundamentals Playground',
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
  
  // 🎯 TODO: Add methods to run different Dart examples
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('🎯 Dart Playground'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🎯 TODO: Add example buttons here
          
          // 🎯 TODO: Add output display area here
        ],
      ),
    );
  }
}
```

### **Example Classes Template**
```dart
// lib/models/dart_examples.dart - STARTER TEMPLATE
class DartExamples {
  // 🎯 TODO: Implement basic types examples
  static void exploreBasicTypes() {
    // Add your code here
  }
  
  // 🎯 TODO: Implement null safety examples
  static void exploreNullSafety() {
    // Add your code here
  }
}

class FunctionExamples {
  // 🎯 TODO: Implement various function examples
  static String greetUser(String name) {
    // Add your implementation
    return '';
  }
}

// 🎯 TODO: Create Person class hierarchy
abstract class Person {
  // Add your abstract class definition
}

// 🎯 TODO: Create collection examples
class CollectionExamples {
  static void exploreCollections() {
    // Add your collection operations
  }
}

// 🎯 TODO: Create async examples
class AsyncExamples {
  static Future<String> fetchData() async {
    // Add your async implementation
    return '';
  }
}
```

## 🎯 Success Criteria

You've mastered Dart fundamentals when you can:

### **Technical Skills**
- [ ] Write idiomatic Dart code with proper styling
- [ ] Use null safety features effectively
- [ ] Implement object-oriented designs
- [ ] Handle asynchronous operations properly
- [ ] Debug Dart code issues effectively

### **Problem-Solving Skills**
- [ ] Choose appropriate data structures for problems
- [ ] Design clean, maintainable class hierarchies
- [ ] Handle errors and edge cases gracefully
- [ ] Optimize code for performance and readability

### **Professional Skills**
- [ ] Follow Dart naming conventions
- [ ] Write self-documenting code
- [ ] Use modern Dart language features
- [ ] Prepare for Flutter development patterns

## 🔧 Troubleshooting

### Common Dart Issues & Solutions

#### **Null Safety Errors**
```dart
// ❌ Error: Non-nullable variable not initialized
String name;

// ✅ Solution: Initialize or make nullable
String name = 'Default';
String? nullableName;
```

#### **Type Errors**
```dart
// ❌ Error: Type mismatch
int number = '42';

// ✅ Solution: Use proper types or conversion
int number = 42;
int converted = int.parse('42');
```

#### **Async/Await Issues**
```dart
// ❌ Error: Missing await
Future<String> fetchData() {
  return someAsyncOperation();
}

// ✅ Solution: Proper async/await
Future<String> fetchData() async {
  return await someAsyncOperation();
}
```

### Debug Tips
- Use `print()` statements to understand execution flow
- Add type annotations for clarity
- Use the Dart analyzer to catch issues early
- Test edge cases and null values

## 📚 Additional Resources

### **Official Documentation**
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Dart Null Safety](https://dart.dev/null-safety)

### **Practice Resources**
- [DartPad](https://dartpad.dev/) - Online Dart playground
- [Dart SDK](https://dart.dev/get-dart) - Command line tools
- [Dart Packages](https://pub.dev/) - Package repository

## ➡️ What's Next?

Ready for [Lesson 04: Widgets 101](../../modules/lesson_04/) where you'll apply your Dart knowledge to build Flutter UIs!

### **Skills Progression**
```
Lesson 3: Dart Fundamentals
    ↓
Lesson 4: Flutter Widgets
    ↓
Lesson 5: Advanced Layouts
    ↓
Lesson 6: Navigation Systems
```

## 🆘 Need Help?

- **Concept Questions**: Review the [concept documentation](../../modules/lesson_03/concept.md)
- **Code Issues**: Compare with the [complete solution](../../answer/lesson_03/)
- **Dart Syntax**: Check the official Dart language documentation
- **General Support**: Use Flutter community forums and Discord

## 🎉 Congratulations!

You're building the foundational skills every Flutter developer needs. Dart is a powerful, modern language, and mastering it will make your Flutter development journey smooth and enjoyable.

**Keep coding, keep experimenting, and get ready to build amazing Flutter apps! 🚀**