import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

void main() {
  runApp(const DartFundamentalsApp());
}

class DartFundamentalsApp extends StatelessWidget {
  const DartFundamentalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Fundamentals Complete',
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

class _DartPlaygroundScreenState extends State<DartPlaygroundScreen>
    with TickerProviderStateMixin {
  String _output = 'Welcome to Dart Fundamentals!\nTap a button to run examples.';
  bool _isRunning = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
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

  void _runExample(String title, Function example) async {
    setState(() {
      _isRunning = true;
      _output = 'Running: $title\n' + '=' * 40 + '\n';
    });

    _animationController.forward();

    // Capture print output
    List<String> prints = [];

    // Override print temporarily
    void Function(Object?) originalPrint = print;
    print = (Object? object) {
      prints.add(object.toString());
    };

    try {
      await example();
    } catch (e) {
      prints.add('Error: $e');
    }

    // Restore original print
    print = originalPrint;

    setState(() {
      _output += prints.join('\n');
      _isRunning = false;
    });

    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('🎯 Dart Fundamentals Playground'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
            tooltip: 'About Dart Fundamentals',
          ),
        ],
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
              childAspectRatio: 2.2,
              children: [
                _buildExampleButton(
                  'Basic Types',
                  Icons.text_fields,
                  Colors.blue,
                  () => DartExamples.exploreBasicTypes(),
                ),
                _buildExampleButton(
                  'Null Safety',
                  Icons.security,
                  Colors.green,
                  () => NullSafetyExamples.exploreNullSafety(),
                ),
                _buildExampleButton(
                  'Functions',
                  Icons.functions,
                  Colors.orange,
                  () => _runFunctionExamples(),
                ),
                _buildExampleButton(
                  'Classes & OOP',
                  Icons.class_,
                  Colors.purple,
                  () => _runOOPExamples(),
                ),
                _buildExampleButton(
                  'Collections',
                  Icons.list,
                  Colors.teal,
                  () => CollectionExamples.exploreCollections(),
                ),
                _buildExampleButton(
                  'Async/Await',
                  Icons.schedule,
                  Colors.red,
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
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.terminal,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Output Console',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      if (_isRunning)
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          _output,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _output = 'Output cleared. Ready for next example! 🚀';
          });
        },
        icon: const Icon(Icons.clear),
        label: const Text('Clear Output'),
        tooltip: 'Clear Output Console',
      ),
    );
  }

  Widget _buildExampleButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: _isRunning ? null : () => _runExample(title, onPressed),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎯 Dart Fundamentals'),
        content: const Text(
          'This interactive playground demonstrates all the core Dart language features you need to master for Flutter development.\n\n'
          'Each button runs live code examples that show real Dart concepts in action!',
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

  void _runFunctionExamples() {
    print('=== Function Examples ===');
    print(FunctionExamples.greetUser('Flutter Developer'));
    print(FunctionExamples.createProfile('Alice', age: 25, city: 'New York'));
    print('Area: ${FunctionExamples.calculateArea(5.0, 3.0)}');
    print(FunctionExamples.formatDate(day: 15, month: 6, year: 2024));
    print('Square of 7: ${FunctionExamples.square(7)}');

    var doubled = FunctionExamples.processNumbers([1, 2, 3], (x) => x * 2);
    print('Doubled: $doubled');

    FunctionExamples.demonstrateClosure();
    FunctionExamples.demonstrateHigherOrderFunctions();
  }

  void _runOOPExamples() {
    print('=== Object-Oriented Programming ===');

    var developer = Developer(
      name: 'Sarah',
      age: 28,
      programmingLanguages: ['Dart', 'Flutter', 'JavaScript'],
      company: 'Tech Corp',
    );

    developer.introduce();
    developer.writeCode('Dart');
    print('Is adult: ${developer.isAdult}');
    print('Experience level: ${developer.experienceLevel}');

    print('\n--- Instructor with Mixin ---');
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
    print('Students: ${instructor.students}');

    print('\n--- Abstract Classes and Interfaces ---');
    _demonstratePolymorphism();
  }

  void _demonstratePolymorphism() {
    List<Person> people = [
      Developer(
        name: 'John',
        age: 30,
        programmingLanguages: ['Dart'],
        company: 'Flutter Inc',
      ),
      Instructor(
        name: 'Jane',
        age: 35,
        programmingLanguages: ['Dart', 'Kotlin'],
        company: 'Dev Academy',
        subject: 'Mobile Development',
      ),
    ];

    for (var person in people) {
      person.introduce();
    }
  }

  void _runAsyncExamples() async {
    print('=== Asynchronous Programming ===');

    print('Fetching user name...');
    String name = await AsyncExamples.fetchUserName();
    print('User name: $name');

    print('\nTesting error handling...');
    String result = await AsyncExamples.fetchDataWithErrorHandling();
    print(result);

    print('\nParallel execution example...');
    var parallelResult = await AsyncExamples.fetchProfileInParallel();
    print('Parallel result: $parallelResult');

    print('\nDemonstrating streams...');
    await AsyncExamples.demonstrateStreams();

    print('\nStream transformation...');
    await AsyncExamples.demonstrateStreamTransformation();
  }
}

// ============================================================================
// DART EXAMPLES CLASSES
// ============================================================================

class DartExamples {
  static void exploreBasicTypes() {
    print('=== Basic Types in Dart ===');

    // Numbers
    int age = 25;
    double height = 5.9;
    num temperature = 36.5; // Can be int or double

    print('Age: $age (type: ${age.runtimeType})');
    print('Height: $height (type: ${height.runtimeType})');
    print('Temperature: $temperature (type: ${temperature.runtimeType})');

    // Strings
    String name = 'Flutter Developer';
    String multiLine = '''
      This is a
      multi-line string
      with preserved formatting
    ''';

    print('\nName: $name');
    print('Multi-line: $multiLine');

    // String interpolation
    print('Hello, my name is $name and I am $age years old.');
    print('Next year I will be ${age + 1}.');

    // Booleans
    bool isLearning = true;
    bool hasExperience = false;

    print('\nLearning Dart: $isLearning');
    print('Has experience: $hasExperience');

    // Lists (Arrays)
    List<String> frameworks = ['Flutter', 'React Native', 'Ionic'];
    var numbers = <int>[1, 2, 3, 4, 5];

    print('\nFrameworks: $frameworks');
    print('Numbers: $numbers');
    print('First framework: ${frameworks.first}');
    print('Last number: ${numbers.last}');

    // Maps (Dictionaries)
    Map<String, int> scores = {
      'Alice': 95,
      'Bob': 87,
      'Charlie': 92,
    };

    print('\nScores: $scores');
    print('Alice\'s score: ${scores['Alice']}');

    // Sets (Unique collections)
    Set<String> skills = {'Dart', 'Flutter', 'Firebase'};

    print('\nSkills: $skills');
    print('Has Flutter skill: ${skills.contains('Flutter')}');

    // Type checking and casting
    var dynamicValue = 42;
    print('\nDynamic value: $dynamicValue (type: ${dynamicValue.runtimeType})');

    if (dynamicValue is int) {
      print('Dynamic value is an integer: ${dynamicValue * 2}');
    }

    // Constants
    const pi = 3.14159;
    final currentTime = DateTime.now();

    print('\nPi (const): $pi');
    print('Current time (final): $currentTime');
  }
}

class NullSafetyExamples {
  static void exploreNullSafety() {
    print('=== Null Safety in Dart ===');

    // Non-nullable (guaranteed to have a value)
    String definitelyHasValue = 'Hello Flutter';
    print('Non-nullable string: $definitelyHasValue');

    // Nullable (might be null)
    String? mightBeNull;
    print('Nullable string: $mightBeNull');

    // Null-aware operators
    String? nullableString;

    // Null-aware access
    int? length = nullableString?.length;
    print('Length (null-aware): $length');

    // Null coalescing
    String displayName = nullableString ?? 'Default Name';
    print('Display name (null coalescing): $displayName');

    // Null assertion (use carefully!)
    nullableString = 'Now it has a value';
    String definite = nullableString!; // Safe because we just assigned it
    print('Null assertion result: $definite');

    // Late variables (initialized later)
    late String lateInitialized;
    lateInitialized = 'Initialized later in the program';
    print('Late initialized: $lateInitialized');

    // Null-aware method calls
    String? possibleString = 'hello world';
    String? upperCase = possibleString?.toUpperCase();
    print('Uppercase (null-aware): $upperCase');

    // Null-aware cascade
    Map<String, dynamic>? settings = <String, dynamic>{};
    settings
      ?..['theme'] = 'dark'
      ..['fontSize'] = 16
      ..['notifications'] = true;
    print('Settings: $settings');

    // Working with nullable collections
    List<String>? nullableList;
    print('Nullable list length: ${nullableList?.length ?? 0}');

    nullableList = ['item1', 'item2'];
    print('List after assignment: $nullableList');
    print('First item: ${nullableList?.first ?? 'No items'}');

    // Null safety with custom methods
    print('\nCustom null-safe methods:');
    print('Uppercase name: ${getUppercaseName('flutter')}');
    print('Uppercase null: ${getUppercaseName(null)}');

    // Practical example: Safe navigation through object hierarchy
    User? user = User('John', Address('New York', '10001'));
    print('\nUser city: ${user?.address?.city ?? 'Unknown'}');

    user = null;
    print('Null user city: ${user?.address?.city ?? 'Unknown'}');
  }

  static String? getUppercaseName(String? name) {
    return name?.toUpperCase();
  }
}

// Helper classes for null safety examples
class User {
  final String name;
  final Address? address;

  User(this.name, this.address);
}

class Address {
  final String city;
  final String zipCode;

  Address(this.city, this.zipCode);
}

class FunctionExamples {
  // Basic function
  static String greetUser(String name) {
    return 'Hello, $name! Welcome to Dart programming.';
  }

  // Function with optional named parameters
  static String createProfile(String name, {int? age, String? city}) {
    String profile = 'Name: $name';
    if (age != null) profile += ', Age: $age';
    if (city != null) profile += ', City: $city';
    return profile;
  }

  // Function with positional optional parameters
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
  static bool isOdd(int number) => !isEven(number);

  // Higher-order functions
  static List<int> processNumbers(
    List<int> numbers,
    int Function(int) processor,
  ) {
    return numbers.map(processor).toList();
  }

  // Function that returns a function
  static Function(int) createMultiplier(int factor) {
    return (int x) => x * factor;
  }

  // Anonymous functions and closures
  static void demonstrateClosure() {
    print('\n--- Closure Example ---');
    var multiplier = 3;

    var multiplyByThree = (int x) => x * multiplier;

    List<int> numbers = [1, 2, 3, 4, 5];
    var results = numbers.map(multiplyByThree).toList();

    print('Original numbers: $numbers');
    print('Multiplied by $multiplier: $results');

    // Modifying the closure variable
    multiplier = 5;
    var multiplyByFive = (int x) => x * multiplier;
    var newResults = numbers.map(multiplyByFive).toList();
    print('Multiplied by $multiplier: $newResults');
  }

  static void demonstrateHigherOrderFunctions() {
    print('\n--- Higher-Order Functions ---');

    List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    // Using built-in higher-order functions
    var evenNumbers = numbers.where((n) => n % 2 == 0).toList();
    var squares = numbers.map((n) => n * n).toList();
    var sum = numbers.reduce((a, b) => a + b);

    print('Original: $numbers');
    print('Even numbers: $evenNumbers');
    print('Squares: $squares');
    print('Sum: $sum');

    // Custom higher-order function
    var doubler = createMultiplier(2);
    var tripler = createMultiplier(3);

    print('Doubled [1,2,3]: ${[1, 2, 3].map(doubler).toList()}');
    print('Tripled [1,2,3]: ${[1, 2, 3].map(tripler).toList()}');

    // Function composition
    var processedNumbers = numbers
        .where((n) => n % 2 == 0) // Filter even numbers
        .map((n) => n * n) // Square them
        .where((n) => n > 10) // Keep only those > 10
        .toList();

    print('Processed (even → square → >10): $processedNumbers');
  }
}

// ============================================================================
// OBJECT-ORIENTED PROGRAMMING EXAMPLES
// ============================================================================

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

  // Method with default implementation
  String getAgeGroup() {
    if (age < 13) return 'Child';
    if (age < 20) return 'Teenager';
    if (age < 65) return 'Adult';
    return 'Senior';
  }

  // Override toString
  @override
  String toString() => 'Person(name: $name, age: $age)';

  // Override operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person && other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

// Concrete implementation
class Developer extends Person {
  final List<String> programmingLanguages;
  final String company;
  final int yearsOfExperience;

  Developer({
    required String name,
    required int age,
    required this.programmingLanguages,
    required this.company,
    this.yearsOfExperience = 0,
  }) : super(name, age);

  @override
  void introduce() {
    print('I\'m $name, a developer at $company');
    print('I code in: ${programmingLanguages.join(', ')}');
    print('Experience: $yearsOfExperience years');
  }

  // Method specific to Developer
  void writeCode(String language) {
    if (programmingLanguages.contains(language)) {
      print('$name is writing $language code... 💻');
    } else {
      print('$name doesn\'t know $language yet 🤔');
    }
  }

  // Computed property
  String get experienceLevel {
    if (yearsOfExperience < 2) return 'Junior';
    if (yearsOfExperience < 5) return 'Mid-level';
    if (yearsOfExperience < 10) return 'Senior';
    return 'Principal';
  }

  // Method overriding with super
  @override
  String getAgeGroup() {
    String baseGroup = super.getAgeGroup();
    return '$baseGroup Developer';
  }
}

// Mixin for additional capabilities
mixin CanTeach {
  final List<String> _students = [];

  void addStudent(String studentName) {
    _students.add(studentName);
    print('✅ Added $studentName as a student');
  }

  void teachLesson(String topic) {
    print('👨‍🏫 Teaching $topic to ${_students.length} students');
    for (var student in _students) {
      print('  - $student is learning $topic');
    }
  }

  List<String> get students => List.unmodifiable(_students);

  void removeStudent(String studentName) {
    if (_students.remove(studentName)) {
      print('❌ Removed $studentName from students');
    } else {
      print('⚠️ $studentName was not found in students list');
    }
  }
}

// Interface-like abstract class
abstract class Mentor {
  void provideFeedback(String feedback);
  void setGoals(List<String> goals);
}

// Class using mixin and implementing interface
class Instructor extends Developer with CanTeach implements Mentor {
  final String subject;
  List<String> _goals = [];

  Instructor({
    required String name,
    required int age,
    required List<String> programmingLanguages,
    required String company,
    required this.subject,
    int yearsOfExperience = 0,
  }) : super(
          name: name,
          age: age,
          programmingLanguages: programmingLanguages,
          company: company,
          yearsOfExperience: yearsOfExperience,
        );

  @override
  void introduce() {
    super.introduce();
    print('I also teach $subject 📚');
    print('Current students: ${students.length}');
  }

  @override
  void provideFeedback(String feedback) {
    print('💬 Instructor feedback: $feedback');
  }

  @override
  void setGoals(List<String> goals) {
    _goals = List.from(goals);
    print('🎯 Goals set: ${_goals.join(', ')}');
  }

  List<String> get goals => List.unmodifiable(_goals);
}

// ============================================================================
// COLLECTIONS EXAMPLES
// ============================================================================

class CollectionExamples {
  static void exploreCollections() {
    print('=== Collections in Dart ===');

    _exploreBasicCollections();
    _exploreAdvancedOperations();
    _exploreCollectionTransformations();
    _exploreSetOperations();
    _exploreMapOperations();
  }

  static void _exploreBasicCollections() {
    print('\n--- Basic Collections ---');

    // List operations
    List<String> fruits = ['apple', 'banana', 'orange'];
    print('Original fruits: $fruits');

    // Adding elements
    fruits.add('mango');
    fruits.addAll(['grape', 'kiwi']);
    fruits.insert(1, 'strawberry');
    print('After additions: $fruits');

    // Removing elements
    fruits.remove('banana');
    fruits.removeAt(0);
    print('After removals: $fruits');

    // List properties
    print('Length: ${fruits.length}');
    print('Is empty: ${fruits.isEmpty}');
    print('First: ${fruits.first}');
    print('Last: ${fruits.last}');
  }

  static void _exploreAdvancedOperations() {
    print('\n--- Advanced Collection Operations ---');

    List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    print('Numbers: $numbers');

    // Functional programming methods
    var evenNumbers = numbers.where((n) => n % 2 == 0).toList();
    var doubledNumbers = numbers.map((n) => n * 2).toList();
    var sum = numbers.reduce((a, b) => a + b);
    var product = numbers.fold(1, (acc, num) => acc * num);

    print('Even numbers: $evenNumbers');
    print('Doubled: $doubledNumbers');
    print('Sum: $sum');
    print('Product: $product');

    // Conditional operations
    bool hasEvenNumbers = numbers.any((n) => n % 2 == 0);
    bool allPositive = numbers.every((n) => n > 0);
    int? firstEven = numbers.firstWhere((n) => n % 2 == 0, orElse: () => -1);

    print('Has even numbers: $hasEvenNumbers');
    print('All positive: $allPositive');
    print('First even: $firstEven');

    // Take and skip
    var firstThree = numbers.take(3).toList();
    var skipFirstThree = numbers.skip(3).toList();
    var middle = numbers.skip(3).take(4).toList();

    print('First three: $firstThree');
    print('Skip first three: $skipFirstThree');
    print('Middle elements: $middle');
  }

  static void _exploreCollectionTransformations() {
    print('\n--- Collection Transformations ---');

    List<String> words = ['hello', 'world', 'dart', 'flutter', 'programming'];
    print('Words: $words');

    // Complex transformations
    var longWords = words.where((word) => word.length > 4).toList();
    var uppercaseWords = words.map((word) => word.toUpperCase()).toList();
    var wordLengths = words.map((word) => word.length).toList();

    print('Long words: $longWords');
    print('Uppercase: $uppercaseWords');
    print('Word lengths: $wordLengths');

    // Grouping (manual implementation)
    Map<int, List<String>> wordsByLength = {};
    for (var word in words) {
      int length = word.length;
      wordsByLength.putIfAbsent(length, () => []).add(word);
    }
    print('Words by length: $wordsByLength');

    // Flattening nested collections
    List<List<int>> nestedNumbers = [
      [1, 2, 3],
      [4, 5],
      [6, 7, 8, 9]
    ];
    var flattened = nestedNumbers.expand((list) => list).toList();
    print('Nested: $nestedNumbers');
    print('Flattened: $flattened');
  }

  static void _exploreSetOperations() {
    print('\n--- Set Operations ---');

    Set<String> colors = {'red', 'green', 'blue', 'yellow'};
    Set<String> primaryColors = {'red', 'blue', 'yellow'};
    Set<String> warmColors = {'red', 'orange', 'yellow'};

    print('Colors: $colors');
    print('Primary colors: $primaryColors');
    print('Warm colors: $warmColors');

    // Set operations
    var intersection = colors.intersection(primaryColors);
    var union = colors.union(warmColors);
    var difference = colors.difference(primaryColors);

    print('Colors ∩ Primary: $intersection');
    print('Colors ∪ Warm: $union');
    print('Colors - Primary: $difference');

    // Set properties
    print('Colors contains red: ${colors.contains('red')}');
    print('Is primary subset of colors: ${primaryColors.every(colors.contains)}');
  }

  static void _exploreMapOperations() {
    print('\n--- Map Operations ---');

    Map<String, int> scores = {
      'Alice': 95,
      'Bob': 87,
      'Charlie': 92,
      'Diana': 98,
    };

    print('Original scores: $scores');

    // Map transformations
    var highScores = Map.fromEntries(
      scores.entries.where((entry) => entry.value >= 90),
    );

    var letterGrades = scores.map((name, score) {
      String grade = score >= 90
          ? 'A'
          : score >= 80
              ? 'B'
              : 'C';
      return MapEntry(name, grade);
    });

    print('High scores (≥90): $highScores');
    print('Letter grades: $letterGrades');

    // Map statistics
    var totalScore = scores.values.reduce((a, b) => a + b);
    var averageScore = totalScore / scores.length;
    var maxScore = scores.values.reduce(math.max);
    var topStudent = scores.entries.reduce((a, b) => a.value > b.value ? a : b);

    print('Total score: $totalScore');
    print('Average score: ${averageScore.toStringAsFixed(1)}');
    print('Max score: $maxScore');
    print('Top student: ${topStudent.key} (${topStudent.value})');
  }
}

// ============================================================================
// ASYNCHRONOUS PROGRAMMING EXAMPLES
// ============================================================================

class AsyncExamples {
  // Basic async function
  static Future<String> fetchUserName() async {
    print('🔄 Fetching username...');
    await Future.delayed(const Duration(seconds: 1));
    return 'JohnDoe_${math.Random().nextInt(1000)}';
  }

  static Future<Map<String, dynamic>> fetchUserProfile() async {
    print('🔄 Fetching user profile...');
    await Future.delayed(const Duration(milliseconds: 800));
    return {
      'name': 'John Doe',
      'email': 'john@example.com',
      'age': 30,
      'location': 'San Francisco',
      'joined': DateTime.now().subtract(const Duration(days: 365)),
    };
  }

  // Error handling with async/await
  static Future<String> fetchDataWithErrorHandling() async {
    try {
      print('🔄 Attempting to fetch data...');
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate random error
      if (math.Random().nextBool()) {
        throw Exception('Random network error occurred');
      }

      return '✅ Success: Data fetched successfully';
    } on Exception catch (e) {
      return '❌ Error: ${e.toString()}';
    } catch (e) {
      return '❌ Unknown error: $e';
    }
  }

  // Sequential vs parallel execution
  static Future<Map<String, dynamic>> fetchCompleteProfileSequential() async {
    print('📊 Sequential execution:');
    final stopwatch = Stopwatch()..start();

    String name = await fetchUserName();
    Map<String, dynamic> profile = await fetchUserProfile();

    stopwatch.stop();

    return {
      'fetchedName': name,
      'profile': profile,
      'executionTime': '${stopwatch.elapsedMilliseconds}ms',
    };
  }

  static Future<Map<String, dynamic>> fetchProfileInParallel() async {
    print('⚡ Parallel execution:');
    final stopwatch = Stopwatch()..start();

    // Both futures run simultaneously
    var futures = await Future.wait([
      fetchUserName(),
      fetchUserProfile(),
    ]);

    stopwatch.stop();

    return {
      'name': futures[0],
      'profile': futures[1],
      'executionTime': '${stopwatch.elapsedMilliseconds}ms',
    };
  }

  // Stream basics
  static Stream<int> countStream() async* {
    print('📡 Starting count stream...');
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      yield i;
    }
    print('📡 Count stream completed');
  }

  // Stream transformation
  static Stream<String> processedCountStream() {
    return countStream()
        .map((count) => 'Count: $count')
        .where((text) => !text.contains('3')); // Skip count 3
  }

  // Multiple stream operations
  static Stream<Map<String, dynamic>> dataStream() async* {
    final random = math.Random();
    for (int i = 0; i < 5; i++) {
      await Future.delayed(Duration(milliseconds: 300 + random.nextInt(700)));
      yield {
        'id': i,
        'value': random.nextInt(100),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
    }
  }

  // Listening to streams
  static Future<void> demonstrateStreams() async {
    print('\n--- Basic Stream Demo ---');

    await for (String message in processedCountStream()) {
      print('📨 Received: $message');
    }

    print('📡 Basic stream demo completed!');
  }

  static Future<void> demonstrateStreamTransformation() async {
    print('\n--- Advanced Stream Transformation ---');

    var subscription = dataStream()
        .where((data) => data['value'] > 50) // Filter high values
        .map((data) => '🎯 High value: ${data['value']} at ${data['id']}')
        .listen(
      (message) => print(message),
      onError: (error) => print('❌ Stream error: $error'),
      onDone: () => print('✅ Stream transformation completed!'),
    );

    // Wait for stream to complete
    await subscription.asFuture();
  }

  // Complex async patterns
  static Future<void> demonstrateComplexAsyncPatterns() async {
    print('\n--- Complex Async Patterns ---');

    // Timeout handling
    try {
      var result = await fetchUserName().timeout(
        const Duration(milliseconds: 500),
        onTimeout: () => 'Timeout_User',
      );
      print('⏰ Result with timeout: $result');
    } catch (e) {
      print('⏰ Timeout error: $e');
    }

    // Retry mechanism
    String retryResult = await _retryAsync(
      () => fetchDataWithErrorHandling(),
      maxAttempts: 3,
    );
    print('🔄 Retry result: $retryResult');

    // Rate limiting
    await _rateLimitedExecution();
  }

  static Future<String> _retryAsync(
    Future<String> Function() operation, {
    int maxAttempts = 3,
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        print('🔄 Attempt $attempt/$maxAttempts');
        return await operation();
      } catch (e) {
        if (attempt == maxAttempts) {
          throw Exception('Failed after $maxAttempts attempts: $e');
        }
        print('⚠️ Attempt $attempt failed, retrying in ${delay.inMilliseconds}ms');
        await Future.delayed(delay);
      }
    }
    throw Exception('Unexpected error in retry mechanism');
  }

  static Future<void> _rateLimitedExecution() async {
    print('🚦 Rate-limited execution:');
    const limit = 3;
    const duration = Duration(seconds: 1);

    for (int i = 0; i < 5; i++) {
      if (i > 0 && i % limit == 0) {
        print('⏸️ Rate limit reached, waiting...');
        await Future.delayed(duration);
      }
      print('📨 Processing item $i');
    }
  }
}