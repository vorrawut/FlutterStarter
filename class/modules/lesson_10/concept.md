# 🔄 Concepts

## 🎯 **Learning Objectives**

By the end of this lesson, you will master:
- **StatefulWidget Lifecycle** - Complete understanding of widget lifecycle and state management
- **setState Method** - Proper usage patterns and performance optimization
- **Lifting State Up** - Sharing state between widgets through parent-child relationships
- **State Management Patterns** - Clean architecture patterns for local state
- **Performance Optimization** - Efficient state updates and widget rebuilding
- **Common Pitfalls** - Anti-patterns to avoid and best practices to follow
- **Testing Strategies** - Unit testing stateful widgets and state changes

## 📚 **Core State Management Concepts**

### **1. Understanding State in Flutter**

State represents data that can change over time and affects the widget's appearance or behavior. In Flutter, state is categorized into two main types:

#### **Ephemeral (Local) State**
```dart
// State that belongs to a single widget
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0; // Ephemeral state - only used by this widget
  
  void _incrementCounter() {
    setState(() {
      _counter++; // Update state and trigger rebuild
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text('Count: $_counter');
  }
}
```

#### **App State (Global) State**
```dart
// State that needs to be shared across multiple widgets
class UserProfile {
  final String name;
  final String email;
  final bool isLoggedIn;
  
  UserProfile({required this.name, required this.email, required this.isLoggedIn});
}

// This would typically be managed by Provider, Riverpod, or Bloc
// We'll cover these in later lessons
```

### **2. StatefulWidget Lifecycle**

Understanding the complete lifecycle is crucial for proper state management:

#### **Widget Lifecycle Phases**
```dart
class LifecycleDemoWidget extends StatefulWidget {
  const LifecycleDemoWidget({super.key});

  @override
  State<LifecycleDemoWidget> createState() {
    print('📦 createState() called');
    return _LifecycleDemoWidgetState();
  }
}

class _LifecycleDemoWidgetState extends State<LifecycleDemoWidget> {
  @override
  void initState() {
    super.initState();
    print('🚀 initState() called - Initialize state here');
    // Initialize controllers, listeners, or async operations
    // DO NOT call setState() here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('🔄 didChangeDependencies() called');
    // Called when dependencies change (InheritedWidget changes)
    // Safe to call setState() here if needed
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ build() called - Building widget tree');
    // Return the widget tree
    // This method should be pure (no side effects)
    return Container(
      child: Text('Lifecycle Demo'),
    );
  }

  @override
  void didUpdateWidget(LifecycleDemoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('🔄 didUpdateWidget() called');
    // Called when parent rebuilds with new configuration
    // Compare old and new widgets here
    if (oldWidget.someProperty != widget.someProperty) {
      // React to changes
      setState(() {
        // Update state based on new widget properties
      });
    }
  }

  @override
  void deactivate() {
    print('⏸️ deactivate() called');
    super.deactivate();
    // Called when widget is removed from tree (temporarily)
    // Rarely used, mostly for debugging
  }

  @override
  void dispose() {
    print('🗑️ dispose() called - Cleanup resources');
    // Dispose controllers, cancel timers, close streams
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }
}
```

#### **Lifecycle Method Usage Guidelines**
```dart
class BestPracticeWidget extends StatefulWidget {
  @override
  State<BestPracticeWidget> createState() => _BestPracticeWidgetState();
}

class _BestPracticeWidgetState extends State<BestPracticeWidget> {
  late AnimationController _animationController;
  late StreamSubscription _subscription;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    // ✅ Initialize controllers and resources
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this, // Requires TickerProviderStateMixin
    );
    
    // ✅ Set up listeners
    _subscription = someStream.listen((data) {
      if (mounted) { // Always check if widget is still in tree
        setState(() {
          // Update state with stream data
        });
      }
    });
    
    // ✅ Start timers or async operations
    _startPeriodicUpdate();
    
    // ❌ Don't call setState() in initState()
    // setState(() {}); // This will cause an error
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // ✅ Access InheritedWidget dependencies
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    
    // ✅ Safe to call setState() if needed
    if (mediaQuery.size.width > 600) {
      setState(() {
        // Update layout for larger screens
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Return widget tree
    // ✅ This method should be pure - no side effects
    // ❌ Don't call setState() in build()
    // ❌ Don't perform expensive operations here
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          transform: Matrix4.rotationZ(_animationController.value * 2 * 3.14159),
          child: Text('Rotating Widget'),
        );
      },
    );
  }

  @override
  void dispose() {
    // ✅ Clean up resources to prevent memory leaks
    _animationController.dispose();
    _subscription.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void _startPeriodicUpdate() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Periodic state update
        });
      }
    });
  }
}
```

### **3. setState Method Deep Dive**

The `setState()` method is the fundamental way to update state in StatefulWidget.

#### **How setState Works**
```dart
class SetStateExample extends StatefulWidget {
  @override
  State<SetStateExample> createState() => _SetStateExampleState();
}

class _SetStateExampleState extends State<SetStateExample> {
  int _counter = 0;
  List<String> _items = [];
  bool _isLoading = false;

  void _incrementCounter() {
    setState(() {
      // All state changes should happen inside setState
      _counter++;
      
      // You can update multiple state variables
      if (_counter % 5 == 0) {
        _items.add('Item $_counter');
      }
    });
    
    // ❌ Don't modify state outside setState
    // _counter++; // This won't trigger a rebuild
  }

  Future<void> _performAsyncOperation() async {
    // ✅ Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Perform async operation
      await Future.delayed(Duration(seconds: 2));
      
      // ✅ Update state after async operation
      if (mounted) { // Always check if widget is still mounted
        setState(() {
          _isLoading = false;
          _items.add('Async result');
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Handle error state
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: $_counter'),
        if (_isLoading) CircularProgressIndicator(),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: Text('Increment'),
        ),
        ElevatedButton(
          onPressed: _performAsyncOperation,
          child: Text('Async Operation'),
        ),
        ...List.generate(_items.length, (index) {
          return ListTile(title: Text(_items[index]));
        }),
      ],
    );
  }
}
```

#### **setState Performance Optimization**
```dart
class OptimizedSetStateWidget extends StatefulWidget {
  @override
  State<OptimizedSetStateWidget> createState() => _OptimizedSetStateWidgetState();
}

class _OptimizedSetStateWidgetState extends State<OptimizedSetStateWidget> {
  int _counter = 0;
  String _expensiveCalculationResult = '';

  // ✅ Separate expensive operations from state updates
  String _performExpensiveCalculation(int value) {
    // Simulate expensive calculation
    return 'Result for $value: ${value * value}';
  }

  void _updateCounter() {
    // ✅ Calculate new values before setState
    final newCounter = _counter + 1;
    final newResult = _performExpensiveCalculation(newCounter);
    
    setState(() {
      // ✅ Keep setState block minimal and fast
      _counter = newCounter;
      _expensiveCalculationResult = newResult;
    });
  }

  void _batchStateUpdates() {
    setState(() {
      // ✅ Batch multiple state changes in one setState call
      _counter += 10;
      _expensiveCalculationResult = _performExpensiveCalculation(_counter);
      // Multiple updates in single setState = single rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ Use const constructors when possible
        const Text('Optimized Widget'),
        Text('Counter: $_counter'),
        Text('Result: $_expensiveCalculationResult'),
        
        // ✅ Extract static widgets to separate methods or const constructors
        _buildStaticSection(),
        
        ElevatedButton(
          onPressed: _updateCounter,
          child: const Text('Update'), // ✅ const text
        ),
      ],
    );
  }

  Widget _buildStaticSection() {
    // ✅ This won't be rebuilt when counter changes
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('This section never changes'),
      ),
    );
  }
}
```

### **4. Lifting State Up Pattern**

When multiple widgets need to share state, lift the state up to their nearest common ancestor.

#### **Basic State Lifting**
```dart
// Parent widget manages shared state
class ParentWidget extends StatefulWidget {
  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  String _sharedText = 'Hello World';
  int _sharedCounter = 0;

  void _updateSharedText(String newText) {
    setState(() {
      _sharedText = newText;
    });
  }

  void _incrementSharedCounter() {
    setState(() {
      _sharedCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pass state down and callbacks up
        DisplayWidget(
          text: _sharedText,
          counter: _sharedCounter,
        ),
        InputWidget(
          onTextChanged: _updateSharedText,
          onCounterIncrement: _incrementSharedCounter,
        ),
        AnotherDisplayWidget(
          text: _sharedText,
          counter: _sharedCounter,
        ),
      ],
    );
  }
}

// Child widgets receive state as parameters
class DisplayWidget extends StatelessWidget {
  final String text;
  final int counter;

  const DisplayWidget({
    super.key,
    required this.text,
    required this.counter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text('Text: $text'),
          Text('Counter: $counter'),
        ],
      ),
    );
  }
}

// Child widgets use callbacks to communicate state changes
class InputWidget extends StatefulWidget {
  final ValueChanged<String> onTextChanged;
  final VoidCallback onCounterIncrement;

  const InputWidget({
    super.key,
    required this.onTextChanged,
    required this.onCounterIncrement,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: widget.onTextChanged, // Pass changes to parent
            decoration: InputDecoration(
              labelText: 'Enter text',
            ),
          ),
          ElevatedButton(
            onPressed: widget.onCounterIncrement, // Pass action to parent
            child: Text('Increment Counter'),
          ),
        ],
      ),
    );
  }
}
```

#### **Advanced State Lifting with Models**
```dart
// State model for complex data
class AppState {
  final String currentUser;
  final List<String> messages;
  final bool isLoading;
  final String? errorMessage;

  const AppState({
    required this.currentUser,
    required this.messages,
    this.isLoading = false,
    this.errorMessage,
  });

  AppState copyWith({
    String? currentUser,
    List<String>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AppState(
      currentUser: currentUser ?? this.currentUser,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Parent widget with complex state management
class AppStateManager extends StatefulWidget {
  @override
  State<AppStateManager> createState() => _AppStateManagerState();
}

class _AppStateManagerState extends State<AppStateManager> {
  AppState _appState = const AppState(
    currentUser: 'Anonymous',
    messages: [],
  );

  void _updateAppState(AppState newState) {
    setState(() {
      _appState = newState;
    });
  }

  void _addMessage(String message) {
    final newMessages = List<String>.from(_appState.messages)..add(message);
    _updateAppState(_appState.copyWith(messages: newMessages));
  }

  void _setLoading(bool loading) {
    _updateAppState(_appState.copyWith(isLoading: loading));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserDisplay(user: _appState.currentUser),
        MessageList(messages: _appState.messages),
        MessageInput(
          onMessageSent: _addMessage,
          isLoading: _appState.isLoading,
        ),
        if (_appState.errorMessage != null)
          ErrorDisplay(error: _appState.errorMessage!),
      ],
    );
  }
}
```

### **5. State Management Best Practices**

#### **Immutable State Pattern**
```dart
// ✅ Use immutable objects for state
class ImmutableState {
  final String title;
  final List<String> items;
  final bool isEnabled;

  const ImmutableState({
    required this.title,
    required this.items,
    required this.isEnabled,
  });

  // ✅ Use copyWith for state updates
  ImmutableState copyWith({
    String? title,
    List<String>? items,
    bool? isEnabled,
  }) {
    return ImmutableState(
      title: title ?? this.title,
      items: items ?? this.items,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class ImmutableStateWidget extends StatefulWidget {
  @override
  State<ImmutableStateWidget> createState() => _ImmutableStateWidgetState();
}

class _ImmutableStateWidgetState extends State<ImmutableStateWidget> {
  ImmutableState _state = const ImmutableState(
    title: 'Initial Title',
    items: [],
    isEnabled: true,
  );

  void _updateTitle(String newTitle) {
    setState(() {
      // ✅ Create new state object instead of mutating
      _state = _state.copyWith(title: newTitle);
    });
  }

  void _addItem(String item) {
    setState(() {
      // ✅ Create new list instead of mutating existing
      final newItems = List<String>.from(_state.items)..add(item);
      _state = _state.copyWith(items: newItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_state.title),
        ...List.generate(_state.items.length, (index) {
          return ListTile(title: Text(_state.items[index]));
        }),
      ],
    );
  }
}
```

#### **State Validation and Error Handling**
```dart
class ValidatedStateWidget extends StatefulWidget {
  @override
  State<ValidatedStateWidget> createState() => _ValidatedStateWidgetState();
}

class _ValidatedStateWidgetState extends State<ValidatedStateWidget> {
  String _email = '';
  String? _emailError;
  bool _isSubmitting = false;

  bool get _isEmailValid => _email.contains('@') && _email.contains('.');

  void _updateEmail(String email) {
    setState(() {
      _email = email;
      // ✅ Validate state on every update
      _emailError = _validateEmail(email);
    });
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!email.contains('@')) return 'Invalid email format';
    if (!email.contains('.')) return 'Invalid email format';
    return null; // Valid
  }

  Future<void> _submitForm() async {
    if (!_isEmailValid) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully')),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _emailError = 'Submission failed: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: _updateEmail,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: _emailError,
            enabled: !_isSubmitting,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isEmailValid && !_isSubmitting ? _submitForm : null,
          child: _isSubmitting
              ? const CircularProgressIndicator()
              : const Text('Submit'),
        ),
      ],
    );
  }
}
```

### **6. Performance Considerations**

#### **Minimizing Widget Rebuilds**
```dart
class PerformantStateWidget extends StatefulWidget {
  @override
  State<PerformantStateWidget> createState() => _PerformantStateWidgetState();
}

class _PerformantStateWidgetState extends State<PerformantStateWidget> {
  int _counter = 0;
  String _unchangingText = 'This never changes';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ build() called'); // Monitor rebuilds

    return Column(
      children: [
        // ✅ Dynamic content
        Text('Counter: $_counter'),
        
        // ✅ Static content wrapped in RepaintBoundary
        RepaintBoundary(
          child: _buildStaticContent(),
        ),
        
        // ✅ Button with const child
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Text('Increment'), // Won't rebuild
        ),
        
        // ✅ Expensive widget isolated
        RepaintBoundary(
          child: ExpensiveWidget(
            // Only pass necessary data
            value: _counter,
          ),
        ),
      ],
    );
  }

  Widget _buildStaticContent() {
    // This method might be called, but content is static
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_unchangingText),
      ),
    );
  }
}

// ✅ Separate expensive widgets
class ExpensiveWidget extends StatelessWidget {
  final int value;

  const ExpensiveWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    print('💰 ExpensiveWidget build() called');
    
    // Simulate expensive operation
    final result = _performExpensiveCalculation(value);
    
    return Card(
      child: Text('Expensive Result: $result'),
    );
  }

  String _performExpensiveCalculation(int value) {
    // Simulate expensive calculation
    var result = 0;
    for (int i = 0; i < 1000000; i++) {
      result += i * value;
    }
    return result.toString();
  }
}
```

### **7. Common Anti-Patterns and Solutions**

#### **Anti-Pattern: setState in build()**
```dart
// ❌ Anti-pattern: Calling setState in build
class BadStateWidget extends StatefulWidget {
  @override
  State<BadStateWidget> createState() => _BadStateWidgetState();
}

class _BadStateWidgetState extends State<BadStateWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    // ❌ NEVER do this - infinite rebuild loop
    if (_counter < 10) {
      setState(() {
        _counter++;
      });
    }

    return Text('Counter: $_counter');
  }
}

// ✅ Correct approach: Use lifecycle methods
class GoodStateWidget extends StatefulWidget {
  @override
  State<GoodStateWidget> createState() => _GoodStateWidgetState();
}

class _GoodStateWidgetState extends State<GoodStateWidget> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // ✅ Initialize state in initState
    _counter = 0;
    
    // ✅ Use post-frame callback if you need to update state after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_counter < 10) {
        setState(() {
          _counter++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Counter: $_counter');
  }
}
```

#### **Anti-Pattern: Not checking mounted**
```dart
// ❌ Anti-pattern: Not checking if widget is mounted
class BadAsyncWidget extends StatefulWidget {
  @override
  State<BadAsyncWidget> createState() => _BadAsyncWidgetState();
}

class _BadAsyncWidgetState extends State<BadAsyncWidget> {
  String _data = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await fetchDataFromAPI();
    
    // ❌ Widget might be disposed by now
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(_data);
  }
}

// ✅ Correct approach: Check mounted before setState
class GoodAsyncWidget extends StatefulWidget {
  @override
  State<GoodAsyncWidget> createState() => _GoodAsyncWidgetState();
}

class _GoodAsyncWidgetState extends State<GoodAsyncWidget> {
  String _data = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await fetchDataFromAPI();
      
      // ✅ Always check if widget is still mounted
      if (mounted) {
        setState(() {
          _data = data;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _data = 'Error: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_data);
  }
}
```

### **8. Testing Stateful Widgets**

#### **Unit Testing State Changes**
```dart
// Testable stateful widget
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void increment() {
    setState(() {
      _counter++;
    });
  }

  void decrement() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_counter', key: const Key('counter_text')),
        ElevatedButton(
          key: const Key('increment_button'),
          onPressed: increment,
          child: const Text('Increment'),
        ),
        ElevatedButton(
          key: const Key('decrement_button'),
          onPressed: decrement,
          child: const Text('Decrement'),
        ),
      ],
    );
  }
}

// Test file (test/counter_widget_test.dart)
void main() {
  group('CounterWidget Tests', () {
    testWidgets('should increment counter when increment button is pressed', (tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: CounterWidget()));
      
      // Assert initial state
      expect(find.text('0'), findsOneWidget);
      
      // Act
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();
      
      // Assert
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('should decrement counter when decrement button is pressed', (tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: CounterWidget()));
      
      // First increment to have a positive number
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();
      
      // Act
      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();
      
      // Assert
      expect(find.text('0'), findsOneWidget);
    });
  });
}
```

## 🛠️ **Clean Architecture with setState**

### **State Management Layer Pattern**
```dart
// Domain layer - Business logic
abstract class CounterRepository {
  Future<int> getCurrentCount();
  Future<void> saveCount(int count);
}

class CounterUseCase {
  final CounterRepository repository;
  
  CounterUseCase(this.repository);
  
  Future<int> incrementCounter() async {
    final currentCount = await repository.getCurrentCount();
    final newCount = currentCount + 1;
    await repository.saveCount(newCount);
    return newCount;
  }
}

// Presentation layer - Widget with clean architecture
class CleanArchitectureCounterWidget extends StatefulWidget {
  final CounterUseCase counterUseCase;
  
  const CleanArchitectureCounterWidget({
    super.key,
    required this.counterUseCase,
  });

  @override
  State<CleanArchitectureCounterWidget> createState() => 
      _CleanArchitectureCounterWidgetState();
}

class _CleanArchitectureCounterWidgetState 
    extends State<CleanArchitectureCounterWidget> {
  int _counter = 0;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialCount();
  }

  Future<void> _loadInitialCount() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final count = await widget.counterUseCase.repository.getCurrentCount();
      if (mounted) {
        setState(() {
          _counter = count;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = error.toString();
        });
      }
    }
  }

  Future<void> _incrementCounter() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newCount = await widget.counterUseCase.incrementCounter();
      if (mounted) {
        setState(() {
          _counter = newCount;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = error.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isLoading) const CircularProgressIndicator(),
        if (_errorMessage != null) 
          Text('Error: $_errorMessage', style: TextStyle(color: Colors.red)),
        Text('Count: $_counter'),
        ElevatedButton(
          onPressed: _isLoading ? null : _incrementCounter,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

## 🌟 **Key Takeaways**

1. **Lifecycle Mastery** - Understand when each lifecycle method is called and their appropriate uses
2. **setState Efficiency** - Keep setState blocks minimal and batch state updates
3. **State Architecture** - Use immutable state objects and proper state lifting patterns
4. **Performance Focus** - Minimize rebuilds with const constructors and RepaintBoundary
5. **Error Handling** - Always check `mounted` before calling setState in async operations
6. **Testing Strategy** - Write comprehensive tests for state changes and user interactions
7. **Clean Architecture** - Separate business logic from UI state management

Understanding setState and StatefulWidget lifecycle is fundamental to all other state management patterns in Flutter. These concepts form the foundation for Provider, Riverpod, Bloc, and other state management solutions we'll explore in upcoming lessons.

**Ready to master the foundation of Flutter state management? 🔄✨**