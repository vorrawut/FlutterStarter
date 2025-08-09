# 🎯 Lesson 03: Dart Fundamentals for Flutter - Concepts

## 🎯 **Learning Objectives**

By the end of this lesson, you will master:
- **🔤 Dart Type System** - Variables, types, and null safety fundamentals
- **⚡ Functions & Methods** - Parameters, arrow functions, and higher-order functions
- **🏗️ Object-Oriented Programming** - Classes, inheritance, mixins, and abstractions
- **📦 Collections & Iterables** - Lists, maps, sets, and powerful collection operations
- **🔄 Asynchronous Programming** - Futures, async/await, streams, and error handling
- **✨ Modern Dart Features** - Extension methods, generics, and advanced language features

## 📚 **Why Dart for Flutter?**

Dart was specifically chosen for Flutter development because it provides the **perfect balance** of features needed for mobile development:

### **🚀 Performance Advantages**
```dart
// Dart compiles to native code for optimal performance
class PerformanceDemo {
  // Ahead-of-time (AOT) compilation for production
  // Just-in-time (JIT) compilation for development
  
  // Hot reload enabled by JIT during development
  void updateUI() {
    // Changes reflect instantly without losing state
  }
}
```

### **🎯 Developer Experience**
```dart
// Clean, readable syntax similar to Java/JavaScript
String greetUser(String name) => 'Hello, $name!';

// Powerful tooling with static analysis
final List<String> fruits = ['apple', 'banana']; // Type inference
// fruits.add(123); // ← Compile-time error caught by analyzer
```

### **🔧 Flutter Integration**
```dart
// Dart and Flutter are designed together
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Seamless integration!');
  }
}
```

## 🔤 **Dart Type System Mastery**

### **1. Basic Types Foundation**

Dart provides a rich set of built-in types that form the foundation of all Flutter applications:

```dart
// Number Types
class NumberTypes {
  // Integer - whole numbers
  int userAge = 25;
  int maxUsers = 100;
  
  // Double - decimal numbers
  double temperature = 36.5;
  double pi = 3.14159;
  
  // Num - can be either int or double
  num flexibleNumber = 42;        // int
  num anotherNumber = 42.5;       // double
  
  // Numeric operations
  void demonstrateOperations() {
    int a = 10;
    int b = 3;
    
    print('Addition: ${a + b}');       // 13
    print('Division: ${a / b}');       // 3.3333...
    print('Integer Division: ${a ~/ b}'); // 3
    print('Modulo: ${a % b}');         // 1
    print('Power: ${a.pow(2)}');       // 100 (requires import 'dart:math')
  }
}
```

```dart
// String Types and Operations
class StringTypes {
  // Basic string declaration
  String singleQuotes = 'Hello Flutter';
  String doubleQuotes = "Hello Dart";
  
  // Multi-line strings
  String multiLine = '''
    This is a
    multi-line
    string
  ''';
  
  String anotherMultiLine = """
    Double quotes also
    work for multi-line
  """;
  
  // String interpolation
  void demonstrateInterpolation() {
    String name = 'Flutter Developer';
    int experience = 2;
    
    // Simple interpolation
    print('I am a $name');
    
    // Expression interpolation
    print('I have ${experience + 1} years of experience');
    
    // Method call interpolation
    print('Name length: ${name.length}');
    print('Uppercase: ${name.toUpperCase()}');
  }
  
  // String methods
  void stringOperations() {
    String text = '  Flutter Development  ';
    
    print('Original: "$text"');
    print('Trimmed: "${text.trim()}"');
    print('Contains Flutter: ${text.contains('Flutter')}');
    print('Starts with space: ${text.startsWith(' ')}');
    print('Replace: ${text.replaceAll('Flutter', 'Dart')}');
    print('Split: ${text.trim().split(' ')}');
    print('Substring: ${text.substring(2, 9)}');
  }
}
```

```dart
// Boolean and Comparison Operations
class BooleanTypes {
  bool isLoggedIn = false;
  bool hasPermission = true;
  
  void demonstrateLogic() {
    bool condition1 = true;
    bool condition2 = false;
    
    // Logical operators
    print('AND: ${condition1 && condition2}');  // false
    print('OR: ${condition1 || condition2}');   // true
    print('NOT: ${!condition1}');               // false
    
    // Comparison operators
    int a = 10, b = 20;
    print('Equal: ${a == b}');          // false
    print('Not equal: ${a != b}');      // true
    print('Greater: ${a > b}');         // false
    print('Less or equal: ${a <= b}');  // true
    
    // Ternary operator
    String result = a > b ? 'a is greater' : 'b is greater or equal';
    print('Ternary result: $result');
  }
}
```

### **2. Null Safety Revolution**

Dart's null safety system prevents null pointer exceptions at compile time:

```dart
// Null Safety Fundamentals
class NullSafetyMastery {
  // Non-nullable types (guaranteed to have a value)
  String definitelyHasValue = 'Never null';
  int alwaysPresent = 42;
  
  // Nullable types (might be null)
  String? mightBeNull;
  int? optionalNumber;
  
  void demonstrateNullSafety() {
    // Null-aware operators
    String? nullableString;
    
    // 1. Null-aware access operator (?.)
    int? length = nullableString?.length;
    print('Length: $length'); // null
    
    // 2. Null coalescing operator (??)
    String displayText = nullableString ?? 'Default text';
    print('Display: $displayText'); // 'Default text'
    
    // 3. Null-aware assignment (??=)
    nullableString ??= 'Assigned because it was null';
    print('After assignment: $nullableString');
    
    // 4. Null assertion operator (!) - use carefully!
    String? definitelyNotNull = 'I have a value';
    int definiteLength = definitelyNotNull!.length; // Safe because we know it's not null
    print('Definite length: $definiteLength');
  }
  
  // Safe navigation patterns
  String getProcessedName(String? name) {
    // Chaining null-aware operators
    return name?.trim().toUpperCase() ?? 'UNKNOWN';
  }
  
  // Late initialization
  late String lateInitialized;
  late final String lateAndFinal;
  
  void initializeLateVariables() {
    // Late variables must be initialized before use
    lateInitialized = 'Initialized when needed';
    lateAndFinal = 'Set once, read many times';
  }
  
  // Null-aware cascade operator
  void configurePerson(Person? person) {
    person
      ?..name = 'Updated Name'
      ..age = 30
      ..email = 'new@example.com';
  }
}
```

### **3. Advanced Type Features**

```dart
// Type Aliases and Generics
typedef UserID = String;
typedef Validator<T> = bool Function(T value);

class AdvancedTypes<T> {
  // Generic type parameter
  final T value;
  final Validator<T>? validator;
  
  AdvancedTypes(this.value, [this.validator]);
  
  bool isValid() => validator?.call(value) ?? true;
  
  // Generic methods
  U transform<U>(U Function(T) transformer) {
    return transformer(value);
  }
}

// Extension methods - add functionality to existing types
extension StringExtensions on String {
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
  
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
  
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return substring(0, maxLength - suffix.length) + suffix;
  }
}

// Usage example
void useExtensions() {
  String email = 'user@example.com';
  print('Is valid email: ${email.isValidEmail}');
  
  String name = 'john doe';
  print('Capitalized: ${name.capitalize()}');
  
  String longText = 'This is a very long text that needs truncating';
  print('Truncated: ${longText.truncate(20)}');
}
```

## ⚡ **Functions & Methods Excellence**

### **1. Function Declaration Patterns**

```dart
// Function Declaration Patterns
class FunctionPatterns {
  // Basic function
  String greetUser(String name) {
    return 'Hello, $name!';
  }
  
  // Arrow function (for simple expressions)
  String greetUserShort(String name) => 'Hello, $name!';
  
  // Optional positional parameters
  double calculateArea(double width, [double height = 1.0]) {
    return width * height;
  }
  
  // Named parameters
  String createUserProfile({
    required String name,
    required String email,
    int? age,
    String city = 'Unknown',
  }) {
    String profile = 'Name: $name, Email: $email';
    if (age != null) profile += ', Age: $age';
    profile += ', City: $city';
    return profile;
  }
  
  // Function with callback
  void processData(
    List<int> data,
    void Function(int) processor,
  ) {
    for (int item in data) {
      processor(item);
    }
  }
  
  // Higher-order function
  List<R> mapList<T, R>(
    List<T> list,
    R Function(T) mapper,
  ) {
    return list.map(mapper).toList();
  }
}
```

### **2. Advanced Function Concepts**

```dart
// Closures and Lexical Scope
class ClosureExamples {
  // Function returning a function
  Function createMultiplier(int factor) {
    return (int value) => value * factor;
  }
  
  // Closure with captured variables
  Function createCounter() {
    int count = 0;
    return () => ++count;
  }
  
  void demonstrateClosures() {
    // Create specialized functions
    var doubler = createMultiplier(2);
    var tripler = createMultiplier(3);
    
    print('Double 5: ${doubler(5)}'); // 10
    print('Triple 4: ${tripler(4)}'); // 12
    
    // Stateful closures
    var counter1 = createCounter();
    var counter2 = createCounter();
    
    print('Counter 1: ${counter1()}'); // 1
    print('Counter 1: ${counter1()}'); // 2
    print('Counter 2: ${counter2()}'); // 1 (independent state)
  }
  
  // Function composition
  T compose<T>(T Function() fn1, T Function(T) fn2) {
    return fn2(fn1());
  }
  
  // Recursive functions
  int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
  }
  
  int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
  }
}
```

## 🏗️ **Object-Oriented Programming Mastery**

### **1. Classes and Objects**

```dart
// Basic Class Structure
class Person {
  // Instance variables
  final String name;
  int age;
  String? email;
  
  // Static variables
  static int totalPersons = 0;
  
  // Constructor
  Person(this.name, this.age, [this.email]) {
    totalPersons++;
  }
  
  // Named constructor
  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        age = json['age'],
        email = json['email'] {
    totalPersons++;
  }
  
  // Factory constructor
  factory Person.create(String name, int age) {
    if (age < 0) {
      throw ArgumentError('Age cannot be negative');
    }
    return Person(name, age);
  }
  
  // Getters
  String get displayName => email != null ? '$name ($email)' : name;
  bool get isAdult => age >= 18;
  
  // Setters
  set email(String? newEmail) {
    if (newEmail != null && !newEmail.contains('@')) {
      throw ArgumentError('Invalid email format');
    }
    _email = newEmail;
  }
  
  // Methods
  void celebrateBirthday() {
    age++;
    print('$name is now $age years old!');
  }
  
  void introduce() {
    print('Hi, I\'m $name and I\'m $age years old');
  }
  
  // Static methods
  static void printTotalPersons() {
    print('Total persons created: $totalPersons');
  }
  
  // Override toString
  @override
  String toString() => 'Person(name: $name, age: $age, email: $email)';
  
  // Override equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age;
  
  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}
```

### **2. Inheritance and Polymorphism**

```dart
// Abstract base class
abstract class Vehicle {
  final String brand;
  final String model;
  double _speed = 0;
  
  Vehicle(this.brand, this.model);
  
  // Abstract methods (must be implemented by subclasses)
  void startEngine();
  void stopEngine();
  double get maxSpeed;
  
  // Concrete methods (can be inherited or overridden)
  void accelerate(double amount) {
    _speed = (_speed + amount).clamp(0, maxSpeed);
    print('$brand $model is now going ${_speed.toStringAsFixed(1)} km/h');
  }
  
  void brake(double amount) {
    _speed = (_speed - amount).clamp(0, maxSpeed);
    print('$brand $model slowed down to ${_speed.toStringAsFixed(1)} km/h');
  }
  
  // Virtual method (can be overridden)
  void displayInfo() {
    print('Vehicle: $brand $model');
  }
  
  double get currentSpeed => _speed;
}

// Concrete implementation
class Car extends Vehicle {
  final int numberOfDoors;
  final String fuelType;
  bool _engineRunning = false;
  
  Car({
    required String brand,
    required String model,
    required this.numberOfDoors,
    required this.fuelType,
  }) : super(brand, model);
  
  @override
  void startEngine() {
    if (!_engineRunning) {
      _engineRunning = true;
      print('$brand $model engine started!');
    }
  }
  
  @override
  void stopEngine() {
    if (_engineRunning) {
      _engineRunning = false;
      _speed = 0;
      print('$brand $model engine stopped.');
    }
  }
  
  @override
  double get maxSpeed => 200.0; // km/h
  
  @override
  void displayInfo() {
    super.displayInfo();
    print('Type: Car, Doors: $numberOfDoors, Fuel: $fuelType');
  }
  
  // Car-specific methods
  void honk() {
    print('$brand $model: Beep beep!');
  }
}

class Motorcycle extends Vehicle {
  final bool hasSidecar;
  
  Motorcycle({
    required String brand,
    required String model,
    this.hasSidecar = false,
  }) : super(brand, model);
  
  @override
  void startEngine() {
    print('$brand $model motorcycle engine roars to life!');
  }
  
  @override
  void stopEngine() {
    print('$brand $model motorcycle engine turns off.');
  }
  
  @override
  double get maxSpeed => 300.0; // km/h
  
  @override
  void displayInfo() {
    super.displayInfo();
    print('Type: Motorcycle, Sidecar: ${hasSidecar ? 'Yes' : 'No'}');
  }
  
  void wheelie() {
    if (currentSpeed > 20) {
      print('$brand $model performs an epic wheelie!');
    } else {
      print('Need more speed for a wheelie!');
    }
  }
}
```

### **3. Mixins and Advanced Features**

```dart
// Mixins for shared functionality
mixin CanFly {
  double altitude = 0;
  
  void takeOff() {
    altitude = 100;
    print('Taking off! Now at ${altitude}m altitude');
  }
  
  void land() {
    altitude = 0;
    print('Landing complete. Safe on the ground.');
  }
  
  void climb(double meters) {
    altitude += meters;
    print('Climbed to ${altitude}m altitude');
  }
  
  void descend(double meters) {
    altitude = (altitude - meters).clamp(0, double.infinity);
    print('Descended to ${altitude}m altitude');
  }
}

mixin CanFloat {
  bool isFloating = false;
  
  void startFloating() {
    isFloating = true;
    print('Now floating on water');
  }
  
  void stopFloating() {
    isFloating = false;
    print('No longer floating');
  }
}

// Multiple mixins usage
class Seaplane extends Vehicle with CanFly, CanFloat {
  Seaplane(String brand, String model) : super(brand, model);
  
  @override
  void startEngine() {
    print('$brand $model seaplane engine started with a splash!');
  }
  
  @override
  void stopEngine() {
    print('$brand $model seaplane engine stopped.');
  }
  
  @override
  double get maxSpeed => 250.0;
  
  // Override mixin method
  @override
  void takeOff() {
    if (isFloating) {
      super.takeOff();
    } else {
      print('Cannot take off - not on water!');
    }
  }
}

// Interface-like behavior with abstract classes
abstract class Drawable {
  void draw();
  void resize(double factor);
}

class Circle implements Drawable {
  double radius;
  
  Circle(this.radius);
  
  @override
  void draw() {
    print('Drawing a circle with radius $radius');
  }
  
  @override
  void resize(double factor) {
    radius *= factor;
    print('Circle resized to radius $radius');
  }
  
  double get area => 3.14159 * radius * radius;
}
```

## 📦 **Collections & Iterables Mastery**

### **1. List Operations**

```dart
class ListMastery {
  void demonstrateListOperations() {
    // List creation
    List<String> fruits = ['apple', 'banana', 'orange'];
    var numbers = <int>[1, 2, 3, 4, 5];
    List<String> emptyList = [];
    
    // Adding elements
    fruits.add('mango');
    fruits.addAll(['grape', 'kiwi']);
    fruits.insert(1, 'strawberry');
    fruits.insertAll(0, ['pineapple', 'coconut']);
    
    // Removing elements
    fruits.remove('banana');
    fruits.removeAt(0);
    fruits.removeLast();
    fruits.removeWhere((fruit) => fruit.length < 5);
    
    // List methods
    print('First: ${fruits.first}');
    print('Last: ${fruits.last}');
    print('Length: ${fruits.length}');
    print('Is empty: ${fruits.isEmpty}');
    print('Contains apple: ${fruits.contains('apple')}');
    
    // Iteration
    fruits.forEach((fruit) => print('Fruit: $fruit'));
    
    for (int i = 0; i < fruits.length; i++) {
      print('Index $i: ${fruits[i]}');
    }
    
    for (String fruit in fruits) {
      print('Enhanced for: $fruit');
    }
  }
  
  void advancedListOperations() {
    List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    
    // Functional operations
    var evenNumbers = numbers.where((n) => n % 2 == 0).toList();
    var squaredNumbers = numbers.map((n) => n * n).toList();
    var firstThree = numbers.take(3).toList();
    var skipFirstThree = numbers.skip(3).toList();
    
    // Reduce and fold
    var sum = numbers.reduce((a, b) => a + b);
    var product = numbers.fold(1, (acc, n) => acc * n);
    
    // Any and every
    bool hasEvenNumbers = numbers.any((n) => n % 2 == 0);
    bool allPositive = numbers.every((n) => n > 0);
    
    // Sorting
    List<String> names = ['Charlie', 'Alice', 'Bob', 'David'];
    names.sort(); // In-place sorting
    var sortedByLength = [...names]..sort((a, b) => a.length.compareTo(b.length));
    
    print('Even numbers: $evenNumbers');
    print('Squared: $squaredNumbers');
    print('Sum: $sum, Product: $product');
    print('Has even: $hasEvenNumbers, All positive: $allPositive');
    print('Sorted names: $names');
    print('Sorted by length: $sortedByLength');
  }
}
```

### **2. Map Operations**

```dart
class MapMastery {
  void demonstrateMapOperations() {
    // Map creation
    Map<String, int> scores = {
      'Alice': 95,
      'Bob': 87,
      'Charlie': 92,
    };
    
    var emptyMap = <String, double>{};
    
    // Adding and updating
    scores['David'] = 88;
    scores.putIfAbsent('Eve', () => 90);
    scores.update('Alice', (value) => value + 5);
    scores.updateAll((key, value) => value + 2);
    
    // Accessing values
    int? aliceScore = scores['Alice'];
    int bobScore = scores['Bob'] ?? 0;
    
    // Map properties
    print('Keys: ${scores.keys}');
    print('Values: ${scores.values}');
    print('Entries: ${scores.entries}');
    print('Length: ${scores.length}');
    print('Is empty: ${scores.isEmpty}');
    
    // Iteration
    scores.forEach((name, score) {
      print('$name scored $score');
    });
    
    for (MapEntry<String, int> entry in scores.entries) {
      print('${entry.key}: ${entry.value}');
    }
    
    // Functional operations on maps
    var highScorers = scores.entries
        .where((entry) => entry.value > 90)
        .map((entry) => entry.key)
        .toList();
    
    var scoreCategories = scores.map((name, score) {
      String category = score >= 90 ? 'Excellent' : 'Good';
      return MapEntry(name, category);
    });
    
    print('High scorers: $highScorers');
    print('Categories: $scoreCategories');
  }
}
```

### **3. Set Operations**

```dart
class SetMastery {
  void demonstrateSetOperations() {
    // Set creation
    Set<String> primaryColors = {'red', 'blue', 'yellow'};
    var secondaryColors = <String>{'green', 'orange', 'purple'};
    
    // Adding elements
    primaryColors.add('white'); // Won't add duplicates
    primaryColors.addAll(['black', 'red']); // 'red' won't be added again
    
    // Set operations
    Set<String> allColors = primaryColors.union(secondaryColors);
    Set<String> commonColors = primaryColors.intersection({'red', 'green', 'blue'});
    Set<String> uniqueToPrimary = primaryColors.difference(secondaryColors);
    
    // Checking membership
    bool hasRed = primaryColors.contains('red');
    bool isSubset = {'red', 'blue'}.every(primaryColors.contains);
    
    print('Primary colors: $primaryColors');
    print('All colors: $allColors');
    print('Common colors: $commonColors');
    print('Unique to primary: $uniqueToPrimary');
    print('Has red: $hasRed');
    print('Is subset: $isSubset');
  }
}
```

## 🔄 **Asynchronous Programming Excellence**

### **1. Futures and Async/Await**

```dart
class AsyncProgramming {
  // Basic Future
  Future<String> fetchUserData() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    return 'User data loaded';
  }
  
  // Future with error handling
  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      
      // Simulate conditional error
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }
      
      return {
        'id': userId,
        'name': 'John Doe',
        'email': 'john@example.com',
        'avatar': 'https://example.com/avatar.jpg',
      };
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }
  
  // Multiple Futures - Sequential
  Future<String> processUserSequentially(String userId) async {
    try {
      String userData = await fetchUserData();
      Map<String, dynamic> profile = await fetchUserProfile(userId);
      
      return 'Processed: $userData, Profile: ${profile['name']}';
    } catch (e) {
      return 'Error: $e';
    }
  }
  
  // Multiple Futures - Parallel
  Future<Map<String, dynamic>> processUserInParallel(String userId) async {
    try {
      // Both futures run simultaneously
      List<dynamic> results = await Future.wait([
        fetchUserData(),
        fetchUserProfile(userId),
      ]);
      
      return {
        'userData': results[0],
        'profile': results[1],
        'processedAt': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception('Parallel processing failed: $e');
    }
  }
  
  // Future with timeout
  Future<String> fetchWithTimeout() async {
    try {
      return await fetchUserData().timeout(
        Duration(seconds: 1),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );
    } catch (e) {
      return 'Timeout error: $e';
    }
  }
  
  // Future combinators
  Future<void> demonstrateFutureCombinators() async {
    List<Future<String>> futures = [
      fetchUserData(),
      Future.delayed(Duration(seconds: 1), () => 'Quick data'),
      Future.delayed(Duration(seconds: 3), () => 'Slow data'),
    ];
    
    // Wait for all to complete
    List<String> allResults = await Future.wait(futures);
    print('All results: $allResults');
    
    // Wait for first to complete
    String firstResult = await Future.any(futures);
    print('First result: $firstResult');
  }
}
```

### **2. Streams and Stream Controllers**

```dart
class StreamProgramming {
  // Basic stream generator
  Stream<int> numberStream() async* {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }
  
  // Stream from existing data
  Stream<String> stringStream() {
    return Stream.fromIterable(['Hello', 'Dart', 'Flutter', 'World']);
  }
  
  // Stream with periodic data
  Stream<DateTime> clockStream() {
    return Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
  }
  
  // Stream transformation
  Stream<String> processedNumberStream() {
    return numberStream()
        .map((number) => 'Number: $number')
        .where((text) => !text.contains('3')); // Skip number 3
  }
  
  // Stream subscription
  void demonstrateStreamSubscription() async {
    Stream<int> numbers = numberStream();
    
    // Listen to stream
    await for (int number in numbers) {
      print('Received: $number');
      
      if (number == 3) {
        print('Breaking at 3');
        break;
      }
    }
  }
  
  // Stream controller for custom streams
  StreamController<String> createMessageStream() {
    final controller = StreamController<String>();
    
    // Add data to stream
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (!controller.isClosed) {
        controller.add('Message at ${DateTime.now()}');
      } else {
        timer.cancel();
      }
    });
    
    return controller;
  }
  
  // Stream operations
  void demonstrateStreamOperations() async {
    Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    
    // Transform operations
    var evenNumbers = numbers.where((n) => n % 2 == 0);
    var squaredNumbers = numbers.map((n) => n * n);
    var firstThree = numbers.take(3);
    
    // Aggregate operations
    int sum = await numbers.fold(0, (acc, n) => acc + n);
    List<int> allNumbers = await numbers.toList();
    int firstNumber = await numbers.first;
    int lastNumber = await numbers.last;
    
    print('Sum: $sum');
    print('All numbers: $allNumbers');
    print('First: $firstNumber, Last: $lastNumber');
    
    // Listen to transformed streams
    await for (int even in evenNumbers) {
      print('Even number: $even');
    }
  }
  
  // Error handling in streams
  Stream<String> streamWithErrors() async* {
    yield 'Success 1';
    yield 'Success 2';
    
    if (DateTime.now().millisecond % 2 == 0) {
      throw Exception('Random stream error');
    }
    
    yield 'Success 3';
  }
  
  void handleStreamErrors() async {
    try {
      await for (String message in streamWithErrors()) {
        print('Message: $message');
      }
    } catch (e) {
      print('Stream error: $e');
    }
  }
}
```

### **3. Advanced Async Patterns**

```dart
class AdvancedAsyncPatterns {
  // Async generators with error handling
  Stream<String> robustDataStream() async* {
    try {
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(Duration(milliseconds: 500));
        
        if (i == 5) {
          throw Exception('Simulated error at item 5');
        }
        
        yield 'Item $i';
      }
    } catch (e) {
      yield 'Error: $e';
      
      // Continue with recovery data
      for (int i = 6; i <= 10; i++) {
        await Future.delayed(Duration(milliseconds: 300));
        yield 'Recovered Item $i';
      }
    }
  }
  
  // Async iteration with custom logic
  Future<void> processStreamWithCustomLogic() async {
    await for (String item in robustDataStream()) {
      print('Processing: $item');
      
      // Custom processing logic
      if (item.contains('Error')) {
        print('Error detected, initiating recovery...');
        continue;
      }
      
      if (item.contains('Item 8')) {
        print('Special handling for item 8');
        // Perform special operation
      }
    }
  }
  
  // Combining multiple streams
  Stream<String> combinedStream() async* {
    yield* stringStream(); // Yield all items from another stream
    yield 'Separator';
    yield* numberStream().map((n) => 'Number: $n');
  }
  
  // Stream broadcasting
  Stream<String> createBroadcastStream() {
    final controller = StreamController<String>.broadcast();
    
    // Generate data
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!controller.isClosed) {
        controller.add('Broadcast: ${DateTime.now().second}');
      } else {
        timer.cancel();
      }
    });
    
    return controller.stream;
  }
  
  // Multiple listeners on broadcast stream
  void demonstrateBroadcastStream() {
    Stream<String> broadcast = createBroadcastStream();
    
    // Listener 1
    broadcast.listen((data) {
      print('Listener 1: $data');
    });
    
    // Listener 2
    broadcast.listen((data) {
      print('Listener 2: $data');
    });
    
    // Both listeners receive the same data
  }
}
```

## 🧠 **Key Concepts Integration**

### **Real-World Example: User Management System**

```dart
// Comprehensive example integrating all concepts
class UserManagementSystem {
  final Map<String, User> _users = {};
  final StreamController<UserEvent> _eventController = StreamController.broadcast();
  
  Stream<UserEvent> get events => _eventController.stream;
  
  // User model with all Dart features
  class User {
    final String id;
    String name;
    String email;
    DateTime createdAt;
    DateTime? lastLoginAt;
    Set<String> roles;
    Map<String, dynamic> preferences;
    
    User({
      required this.id,
      required this.name,
      required this.email,
      Set<String>? roles,
      Map<String, dynamic>? preferences,
    }) : createdAt = DateTime.now(),
         roles = roles ?? {'user'},
         preferences = preferences ?? {};
    
    bool hasRole(String role) => roles.contains(role);
    
    void updatePreference(String key, dynamic value) {
      preferences[key] = value;
    }
    
    @override
    String toString() => 'User(id: $id, name: $name, email: $email)';
  }
  
  // Event system
  abstract class UserEvent {
    final DateTime timestamp = DateTime.now();
  }
  
  class UserCreated extends UserEvent {
    final User user;
    UserCreated(this.user);
  }
  
  class UserUpdated extends UserEvent {
    final User user;
    UserUpdated(this.user);
  }
  
  class UserDeleted extends UserEvent {
    final String userId;
    UserDeleted(this.userId);
  }
  
  // Async operations
  Future<User> createUser({
    required String name,
    required String email,
    Set<String>? roles,
  }) async {
    // Simulate validation delay
    await Future.delayed(Duration(milliseconds: 100));
    
    if (!email.isValidEmail) {
      throw ArgumentError('Invalid email format');
    }
    
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      roles: roles,
    );
    
    _users[user.id] = user;
    _eventController.add(UserCreated(user));
    
    return user;
  }
  
  Future<User?> getUserById(String id) async {
    await Future.delayed(Duration(milliseconds: 50));
    return _users[id];
  }
  
  Future<List<User>> searchUsers({
    String? nameQuery,
    String? emailQuery,
    Set<String>? requiredRoles,
  }) async {
    await Future.delayed(Duration(milliseconds: 200));
    
    return _users.values.where((user) {
      bool matchesName = nameQuery == null || 
          user.name.toLowerCase().contains(nameQuery.toLowerCase());
      bool matchesEmail = emailQuery == null || 
          user.email.toLowerCase().contains(emailQuery.toLowerCase());
      bool hasRequiredRoles = requiredRoles == null || 
          requiredRoles.every(user.hasRole);
      
      return matchesName && matchesEmail && hasRequiredRoles;
    }).toList();
  }
  
  Future<void> updateUser(String id, {
    String? name,
    String? email,
    Set<String>? roles,
  }) async {
    await Future.delayed(Duration(milliseconds: 100));
    
    User? user = _users[id];
    if (user == null) {
      throw ArgumentError('User not found');
    }
    
    if (name != null) user.name = name;
    if (email != null) {
      if (!email.isValidEmail) {
        throw ArgumentError('Invalid email format');
      }
      user.email = email;
    }
    if (roles != null) user.roles = roles;
    
    _eventController.add(UserUpdated(user));
  }
  
  Future<bool> deleteUser(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    
    if (_users.remove(id) != null) {
      _eventController.add(UserDeleted(id));
      return true;
    }
    return false;
  }
  
  // Stream operations
  Stream<User> getUserStream() async* {
    for (User user in _users.values) {
      await Future.delayed(Duration(milliseconds: 100));
      yield user;
    }
  }
  
  void dispose() {
    _eventController.close();
  }
}

// Usage example
void demonstrateUserManagementSystem() async {
  final userSystem = UserManagementSystem();
  
  // Listen to events
  userSystem.events.listen((event) {
    print('Event: ${event.runtimeType} at ${event.timestamp}');
  });
  
  // Create users
  try {
    User admin = await userSystem.createUser(
      name: 'Admin User',
      email: 'admin@example.com',
      roles: {'admin', 'user'},
    );
    
    User regular = await userSystem.createUser(
      name: 'Regular User',
      email: 'user@example.com',
    );
    
    // Search users
    List<User> admins = await userSystem.searchUsers(
      requiredRoles: {'admin'},
    );
    
    print('Admins found: ${admins.length}');
    
    // Update user
    await userSystem.updateUser(regular.id, name: 'Updated User');
    
    // Stream all users
    await for (User user in userSystem.getUserStream()) {
      print('User: ${user.name}');
    }
    
  } catch (e) {
    print('Error: $e');
  } finally {
    userSystem.dispose();
  }
}
```

## 🎯 **Key Takeaways**

### **Dart Language Principles**
1. **Type Safety** - Null safety prevents runtime errors
2. **Object-Oriented** - Everything is an object with clean inheritance
3. **Functional Features** - First-class functions and powerful collections
4. **Async-First** - Built-in support for asynchronous programming
5. **Tooling** - Excellent static analysis and development tools

### **Flutter Integration Points**
- **Widget Trees** leverage Dart's object-oriented nature
- **State Management** uses Dart's reactive programming features
- **Hot Reload** powered by Dart's JIT compilation
- **Performance** benefits from Dart's AOT compilation for production

### **Best Practices**
- Use null safety consistently
- Prefer immutable objects where possible
- Leverage async/await for readable asynchronous code
- Use strong typing for better tooling support
- Follow Dart style guidelines for consistent code

**🚀 With this solid Dart foundation, you're ready to build amazing Flutter applications that are performant, maintainable, and scalable!**
