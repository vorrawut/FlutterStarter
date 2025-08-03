import 'package:flutter/material.dart';

// 🎯 DART FUNDAMENTALS PLAYGROUND - STARTER CODE
// ================================================
// Complete this app by following the workshop guide!

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
  
  // 🎯 TODO: Complete this method to run basic types examples
  void _runBasicTypesExample() {
    setState(() {
      _output = 'Running: Basic Types\n' + '=' * 30 + '\n';
    });
    
    // 🎯 TODO: Add basic types exploration code here
    // Hint: Declare different variable types (int, double, String, bool)
    // Example:
    // int age = 25;
    // String name = 'Flutter Developer';
    // Print them to see the output
    
    setState(() {
      _output += 'TODO: Implement basic types examples!';
    });
  }
  
  // 🎯 TODO: Complete this method to demonstrate null safety
  void _runNullSafetyExample() {
    setState(() {
      _output = 'Running: Null Safety\n' + '=' * 30 + '\n';
    });
    
    // 🎯 TODO: Add null safety examples here
    // Hint: Create nullable and non-nullable variables
    // Use null-aware operators (?, ??, !)
    
    setState(() {
      _output += 'TODO: Implement null safety examples!';
    });
  }
  
  // 🎯 TODO: Complete this method to show function examples
  void _runFunctionExample() {
    setState(() {
      _output = 'Running: Functions\n' + '=' * 30 + '\n';
    });
    
    // 🎯 TODO: Call function examples here
    // Hint: Call functions with different parameter types
    // Use the helper functions you'll create below
    
    setState(() {
      _output += 'TODO: Implement function examples!';
    });
  }
  
  // 🎯 TODO: Complete this method to demonstrate classes
  void _runClassExample() {
    setState(() {
      _output = 'Running: Classes & OOP\n' + '=' * 30 + '\n';
    });
    
    // 🎯 TODO: Create and use class instances here
    // Hint: Create Person objects, call their methods
    
    setState(() {
      _output += 'TODO: Implement class examples!';
    });
  }
  
  // 🎯 TODO: Complete this method to show collections
  void _runCollectionExample() {
    setState(() {
      _output = 'Running: Collections\n' + '=' * 30 + '\n';
    });
    
    // 🎯 TODO: Add collection operations here
    // Hint: Create Lists, Maps, Sets and transform them
    
    setState(() {
      _output += 'TODO: Implement collection examples!';
    });
  }
  
  // 🎯 TODO: Complete this method to demonstrate async
  void _runAsyncExample() async {
    setState(() {
      _output = 'Running: Async Programming\n' + '=' * 30 + '\n';
    });
    
    // 🎯 TODO: Add async/await examples here
    // Hint: Create and await Futures, handle async operations
    
    setState(() {
      _output += 'TODO: Implement async examples!';
    });
  }

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
                // 🎯 TODO: Create buttons for each example type
                _buildExampleButton(
                  'Basic Types',
                  Icons.text_fields,
                  _runBasicTypesExample,
                ),
                _buildExampleButton(
                  'Null Safety',
                  Icons.security,
                  _runNullSafetyExample,
                ),
                _buildExampleButton(
                  'Functions',
                  Icons.functions,
                  _runFunctionExample,
                ),
                _buildExampleButton(
                  'Classes & OOP',
                  Icons.class_,
                  _runClassExample,
                ),
                _buildExampleButton(
                  'Collections',
                  Icons.list,
                  _runCollectionExample,
                ),
                _buildExampleButton(
                  'Async/Await',
                  Icons.schedule,
                  _runAsyncExample,
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
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}

// ============================================================================
// 🎯 TODO: IMPLEMENT THESE HELPER FUNCTIONS
// ============================================================================

// 🎯 TODO: Create a simple greeting function
String greetUser(String name) {
  // Implement this function
  return 'TODO: Return a greeting message';
}

// 🎯 TODO: Create a function with optional parameters
String createProfile(String name, {int? age, String? city}) {
  // Implement this function with optional named parameters
  return 'TODO: Create user profile string';
}

// 🎯 TODO: Create a function with default parameters
double calculateArea(double width, [double height = 1.0]) {
  // Implement this function with default parameter
  return 0.0; // TODO: Calculate and return area
}

// 🎯 TODO: Create an arrow function
int square(int x) => 0; // TODO: Return x squared

// ============================================================================
// 🎯 TODO: IMPLEMENT THESE CLASSES
// ============================================================================

// 🎯 TODO: Create an abstract Person class
abstract class Person {
  // TODO: Add name and age properties
  // TODO: Add abstract introduce method
  // TODO: Add concrete greet method
  // TODO: Add getter for isAdult
}

// 🎯 TODO: Create a Developer class that extends Person
class Developer extends Person {
  // TODO: Add programmingLanguages and company properties
  // TODO: Implement constructor
  // TODO: Implement introduce method
  // TODO: Add writeCode method
}

// 🎯 TODO: Create a mixin for teaching capability
mixin CanTeach {
  // TODO: Add students list
  // TODO: Add addStudent method
  // TODO: Add teachLesson method
}

// 🎯 TODO: Create an Instructor class that uses the mixin
class Instructor extends Developer with CanTeach {
  // TODO: Add subject property
  // TODO: Implement constructor
  // TODO: Override introduce method
}

// ============================================================================
// 🎯 TODO: IMPLEMENT THESE COLLECTION FUNCTIONS
// ============================================================================

void exploreBasicCollections() {
  // 🎯 TODO: Create and manipulate Lists
  List<String> fruits = []; // TODO: Add fruits
  
  // 🎯 TODO: Create and manipulate Maps
  Map<String, int> scores = {}; // TODO: Add scores
  
  // 🎯 TODO: Create and manipulate Sets
  Set<String> skills = {}; // TODO: Add skills
  
  // TODO: Print results
}

void exploreAdvancedCollections() {
  List<int> numbers = [1, 2, 3, 4, 5];
  
  // 🎯 TODO: Use map to transform the list
  // 🎯 TODO: Use where to filter the list
  // 🎯 TODO: Use reduce to aggregate values
  // 🎯 TODO: Use any and every for boolean tests
}

// ============================================================================
// 🎯 TODO: IMPLEMENT THESE ASYNC FUNCTIONS
// ============================================================================

// 🎯 TODO: Create a simple async function
Future<String> fetchUserName() async {
  // TODO: Simulate network delay with Future.delayed
  // TODO: Return a username
  return '';
}

// 🎯 TODO: Create an async function with error handling
Future<String> fetchDataWithErrorHandling() async {
  try {
    // TODO: Simulate async operation that might fail
    // TODO: Handle potential errors
    return '';
  } catch (e) {
    return 'Error: ${e.toString()}';
  }
}

// 🎯 TODO: Create a stream function
Stream<int> countStream() async* {
  // TODO: Yield numbers from 1 to 5 with delays
}

// ============================================================================
// 🎯 COMPLETION CHECKLIST
// ============================================================================
// 
// Basic Types:
// [ ] Declare int, double, String, bool variables
// [ ] Use string interpolation
// [ ] Work with lists, maps, sets
//
// Null Safety:
// [ ] Create nullable and non-nullable variables
// [ ] Use null-aware operators (?, ??, !)
// [ ] Handle null values safely
//
// Functions:
// [ ] Implement functions with different parameter types
// [ ] Use optional and named parameters
// [ ] Create arrow functions
// [ ] Use higher-order functions
//
// Classes & OOP:
// [ ] Create abstract classes
// [ ] Implement inheritance
// [ ] Use mixins
// [ ] Override methods
//
// Collections:
// [ ] Work with Lists, Maps, Sets
// [ ] Use functional programming methods
// [ ] Transform and filter data
//
// Async Programming:
// [ ] Use async/await
// [ ] Handle Futures
// [ ] Work with Streams
// [ ] Implement error handling
//
// ============================================================================