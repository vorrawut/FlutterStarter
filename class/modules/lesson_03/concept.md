# 🎯 Dart Basics for Beginners (30 min)

## 🎯 **Learning Objectives**

By the end of this 30-minute lesson, you will understand:

- **📝 Variables and Basic Types** - How to store and work with data
- **🔢 Simple Functions** - How to organize your code into reusable pieces
- **📋 Lists and Basic Collections** - How to work with multiple items
- **🤔 Making Decisions** - Using if/else statements
- **🔄 Repeating Tasks** - Using loops to repeat code
- **🏗️ Classes and Objects** - Essential OOP concepts for Flutter development

## 📚 **Why Learn Dart?**

Dart is like learning the grammar rules (**syntax**) before writing a story. It's the **programming language** that powers Flutter apps!


[![i'm a dart developer](https://preview.redd.it/xythf1yzyc471.png?width=320&crop=smart&auto=webp&s=9a9478979c44bcae69f29510544cf8edc24044ee "You just insulted my entire race of people.")](https://www.reddit.com/r/ProgrammerHumor/comments/nwe1ij/theres_not_much_more_to_dart_than_flutter/)

### **🧑‍💻 Easy to Read Syntax**

```dart
// This is what Dart code looks like - simple and clear!
void main() {  // main() is the entry point (starting function)
  String message = 'Hello, World!';  // String is a data type for text
  print(message);  // print() is a function that displays output
}
```

**Technical terms**: `syntax`, `programming language`, `function`, `data type`, `variable`

## 📝 **Variables and Data Types**

Think of **variables** like labeled boxes where you store different types of information. Each box has a **data type** that tells the computer what kind of information it contains.

```
📦 Variables are like labeled storage boxes:

┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    int      │    │   double    │    │   String    │    │    bool     │
│   age: 25   │    │ price: 29.99│    │name: "Alice"│    │isStudent:   │
│             │    │             │    │             │    │    true     │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
  whole numbers      decimal numbers      text data        true/false
```

### **1. Basic Data Types**

```dart
// Numbers - like a calculator that stores results
int age = 25;           // int = whole numbers (integers)
double price = 29.99;   // double = decimal numbers
String name = 'Alice';  // String = text (characters in quotes)
bool isStudent = true;  // bool = true or false (boolean values)

// Try it yourself!
void main() {
  print('Name: $name');        // String interpolation
  print('Age: $age');
  print('Price: \$${price}');  // Using variables in text
  print('Is student? $isStudent');
}
```

**Technical terms**: `int` (integer), `double`, `String`, `bool` (boolean), `variable declaration`, `string interpolation`

### **2. Working with Text (Strings)**

Think of **Strings** like writing messages that the computer can read and change.

```dart
// Strings - text wrapped in quotes
String firstName = 'John';
String lastName = "Doe";
String greeting = 'Hello, $firstName!';  // Putting variables inside text

void main() {
  // String methods - like tools for changing text
  print(greeting.toUpperCase());    // HELLO, JOHN!
  print(greeting.toLowerCase());    // hello, john!
  print(greeting.length);           // 12 (counts characters)
  print(greeting.contains('John')); // true
}
```

**Technical terms**: `String`, `string methods`, `toUpperCase()`, `toLowerCase()`, `length property`, `contains() method`

## 🤔 **Making Decisions (If/Else)**

Think of **if/else statements** like asking questions and doing different things based on the answer.

```
🤔 Decision Making Flow:

        ┌─────────────┐
        │  Question:  │
        │ age >= 18?  │
        └──────┬──────┘
               │
               ▼
         ┌─────────────┐
         │ True/False? │
         └──────┬──────┘
                │
       ┌────────┴────────┐
       ▼                 ▼
┌─────────────┐   ┌─────────────┐
│    TRUE     │   │    FALSE    │
│"You are an  │   │"You are a   │
│   adult"    │   │   minor"    │
└─────────────┘   └─────────────┘
```

```dart
void main() {
  int age = 17;
  bool hasLicense = false;

  // Simple if statement - like asking "Is this true?"
  if (age >= 18) {
    print('You are an adult');
  } else {
    print('You are a minor');
  }

  // Multiple conditions - like asking several questions
  if (age >= 18 && hasLicense) {  // && means "and"
    print('You can drive alone');
  } else if (age >= 16) {
    print('You can drive with supervision');
  } else {
    print('You cannot drive yet');
  }
}
```

**Technical terms**: `if statement`, `else statement`, `boolean condition`, `logical operators` (`&&`, `||`, `!`), `comparison operators` (`==`, `!=`, `>`, `<`)

## 📋 **Lists (Collections)**

Think of **Lists** like shopping lists - they hold multiple items in order.

```
📋 List Structure:

fruits = ['apple', 'banana', 'orange']
          ┌─────┬─────┬────────┬───────┐
   Index: │  0  │  1  │   2    │   3   │
          ├─────┼─────┼────────┼───────┤
  Values: │apple│banana│orange │ mango │ ← added with fruits.add('mango')
          └─────┴─────┴────────┴───────┘

💡 Remember: Programming counts from 0, not 1!
   First item is at index 0, second item is at index 1, etc.
```

```dart
void main() {
  // Creating a list - like making a shopping list
  List<String> fruits = ['apple', 'banana', 'orange'];
  List<int> numbers = [1, 2, 3, 4, 5];

  // Adding items - like adding to your shopping list
  fruits.add('mango');
  print('Fruits: $fruits');

  // Accessing items - like reading the 1st item (index 0)
  print('First fruit: ${fruits[0]}');
  print('Last fruit: ${fruits.last}');

  // List properties - like checking your list
  print('How many fruits? ${fruits.length}');
  print('Is list empty? ${fruits.isEmpty}');

  // Going through each item - like checking off your list
  for (String fruit in fruits) {
    print('I need to buy: $fruit');
  }
}
```

**Technical terms**: `List`, `index`, `add() method`, `length property`, `for loop`, `iteration`

## 🔢 **Functions (Reusable Code)**

Think of **functions** like recipes - you write them once and use them many times.

```
🔢 Function Flow:

Input (Parameters) ──► Function (Recipe) ──► Output (Return Value)

Example: addNumbers(5, 3)
     5, 3 ──────────► addNumbers() ──────────► 8
      │                    │                   │
  ingredients         recipe steps          final dish

greetUser("Alice")
   "Alice" ─────────► greetUser() ──────────► "Hello, Alice!"
      │                   │                      │
   your name          greeting recipe        personalized message
```

```dart
// Basic function - like a recipe that takes ingredients and makes something
String greetUser(String name) {
  return 'Hello, $name! Welcome to Flutter!';
}

// Function with multiple inputs (parameters)
int addNumbers(int a, int b) {
  return a + b;
}

// Function that doesn't return anything (void)
void printUserInfo(String name, int age) {
  print('Name: $name');
  print('Age: $age');
}

void main() {
  // Calling functions - like following the recipe
  String message = greetUser('Alice');
  print(message);

  int sum = addNumbers(5, 3);
  print('Sum: $sum');

  printUserInfo('Bob', 25);
}
```

**Technical terms**: `function`, `parameters`, `return value`, `void`, `function call`

## 🔄 **Loops (Repeating Tasks)**

Think of **loops** like doing the same task multiple times automatically.

```
🔄 Loop Visualization:

For Loop: for (int i = 1; i <= 3; i++)

  Start ─► i=1 ─► Print "Count: 1" ─► i=2 ─► Print "Count: 2" ─► i=3 ─► Print "Count: 3" ─► End
           │                        │                        │                        ▲
           └────────────────────────┴────────────────────────┴────────── i++ ────────┘
                                    (repeat while i <= 3)

For-in Loop: for (color in ['red', 'blue'])

  Start ─► color='red' ─► Print "I like red" ─► color='blue' ─► Print "I like blue" ─► End
           └──────────────── loop through each item ────────────────────────────────┘
```

```dart
void main() {
  // For loop - like counting from 1 to 5
  for (int i = 1; i <= 5; i++) {
    print('Count: $i');
  }

  // For-in loop - like going through a list item by item
  List<String> colors = ['red', 'green', 'blue'];
  for (String color in colors) {
    print('I like $color');
  }

  // While loop - like "keep doing this until something changes"
  int countdown = 3;
  while (countdown > 0) {
    print('Countdown: $countdown');
    countdown--;  // Subtract 1
  }
  print('Blast off!');
}
```

**Technical terms**: `for loop`, `for-in loop`, `while loop`, `increment` (`++`), `decrement` (`--`)

## 🏗️ **Classes and Objects (Essential for Flutter)**

Think of **classes** like blueprints for building things, and **objects** like the actual things you build from those blueprints.

```
🏗️ Class vs Object Visualization:

CLASS (Blueprint)                    OBJECTS (Built from blueprint)
┌─────────────────┐                 ┌─────────────────┐  ┌─────────────────┐
│     Person      │  ──────────────►│   alice object  │  │   bob object    │
├─────────────────┤                 ├─────────────────┤  ├─────────────────┤
│ Properties:     │                 │ name: "Alice"   │  │ name: "Bob"     │
│ • String name   │                 │ age: 25         │  │ age: 30         │
│ • int age       │                 └─────────────────┘  └─────────────────┘
├─────────────────┤                          │                    │
│ Methods:        │                          ▼                    ▼
│ • introduce()   │                 alice.introduce()      bob.introduce()
│ • birthday()    │                "Hi, I am Alice"      "Hi, I am Bob"
└─────────────────┘

One blueprint → Many different objects with different data
```

```dart
// Class - like a blueprint for making a person
class Person {
  // Properties - like characteristics of a person
  String name;
  int age;

  // Constructor - like instructions for creating a person
  Person(this.name, this.age);

  // Methods - like actions a person can do
  void introduce() {
    print('Hi, I am $name and I am $age years old');
  }

  void celebrateBirthday() {
    age++;
    print('$name is now $age years old! 🎉');
  }
}

void main() {
  // Creating objects - like building actual people from the blueprint
  Person alice = Person('Alice', 25);
  Person bob = Person('Bob', 30);

  // Using objects - calling their methods
  alice.introduce();
  bob.introduce();

  alice.celebrateBirthday();

  // Accessing properties
  print('Alice is ${alice.age} years old');
}
```

### **Why Classes Matter for Flutter**

In Flutter, everything is a **Widget**, and Widgets are classes!

```dart
// This is how Flutter widgets work - they're classes!
class MyButton extends StatelessWidget {
  final String text;

  MyButton(this.text);  // Constructor

  @override
  Widget build(BuildContext context) {  // Method
    return Text(text);
  }
}

void main() {
  // Creating widget objects
  MyButton button1 = MyButton('Click me!');
  MyButton button2 = MyButton('Press here!');
}
```

**Technical terms**: `class`, `object`, `constructor`, `method`, `property`, `instance`, `Widget`

## 🏃‍♂️ **Practice Exercise (10 minutes)**

Let's combine everything you've learned! Create a Student class using OOP:

```
🧩 All Concepts Working Together:

┌─────────────────────────────────────────────────────────────┐
│                    Student Class                           │
├─────────────────────────────────────────────────────────────┤
│ Properties (Variables):                                     │
│  📝 String name    📋 List<int> grades                      │
├─────────────────────────────────────────────────────────────┤
│ Methods (Functions):                                        │
│  🔢 calculateAverage()  🤔 getLetterGrade()  🔄 displayInfo()│
│        │                    │                    │          │
│        ▼                    ▼                    ▼          │
│   Uses LOOPS           Uses IF/ELSE         Uses ALL        │
│   to add grades        to decide grade      to show data    │
└─────────────────────────────────────────────────────────────┘

Objects Created:
sarah = Student('Sarah', [85, 92, 78, 96, 88])
mike = Student('Mike', [90, 95, 87, 92])
```

```dart
// Student class - blueprint for creating students
class Student {
  // Properties - what every student has
  String name;
  List<int> grades;

  // Constructor - how to create a student
  Student(this.name, this.grades);

  // Method to calculate average
  double calculateAverage() {
    int sum = 0;
    for (int grade in grades) {
      sum += grade;
    }
    return sum / grades.length;
  }

  // Method to get letter grade using if/else
  String getLetterGrade() {
    double average = calculateAverage();
    if (average >= 90) {
      return 'A';
    } else if (average >= 80) {
      return 'B';
    } else if (average >= 70) {
      return 'C';
    } else {
      return 'F';
    }
  }

  // Method to display student info
  void displayInfo() {
    print('Student: $name');
    print('Grades: $grades');
    print('Average: ${calculateAverage().toStringAsFixed(1)}');
    print('Letter Grade: ${getLetterGrade()}');

    // Loop through all grades
    print('\\nAll grades:');
    for (int i = 0; i < grades.length; i++) {
      print('Test ${i + 1}: ${grades[i]}');
    }
  }
}

void main() {
  // Create student objects
  Student sarah = Student('Sarah', [85, 92, 78, 96, 88]);
  Student mike = Student('Mike', [90, 95, 87, 92]);

  // Use the objects
  sarah.displayInfo();
  print('\\n---\\n');
  mike.displayInfo();
}
```

**Your turn**: Try changing the student name and grades, then run the code!

## 🎯 **What You've Learned**

Congratulations! In 30 minutes, you've learned the building blocks of programming:

### **Essential Concepts**

- **Variables** (`int`, `double`, `String`, `bool`) - storing data
- **Functions** - organizing reusable code
- **Lists** - working with multiple items
- **If/Else** - making decisions in code
- **Loops** - repeating tasks automatically
- **Classes and Objects** - blueprints and instances (essential for Flutter widgets)

### **Key Programming Terms**

- `variable declaration`, `data types`, `parameters`, `return value`
- `if statement`, `boolean condition`, `logical operators`
- `List`, `index`, `for loop`, `while loop`, `iteration`
- `function call`, `string interpolation`, `method`
- `class`, `object`, `constructor`, `property`, `instance`, `Widget`

### **Next Steps**

Now you're ready to start building Flutter apps! These concepts are the foundation for:

```
🚀 From Dart Basics to Flutter Apps:

Dart Concepts You Learned     →     Flutter Application
┌──────────────────────────┐         ┌──────────────────────────┐
│ 📝 Variables & Types     │   ──►   │ 📱 Store app data        │
│ 🔢 Functions             │   ──►   │ 🎯 Widget methods        │
│ 📋 Lists                 │   ──►   │ 📜 Handle collections    │
│ 🤔 If/Else               │   ──►   │ 🔀 App logic & navigation│
│ 🔄 Loops                 │   ──►   │ 🔄 Build UI lists        │
│ 🏗️ Classes & Objects     │   ──►   │ 🎨 Create custom widgets │
└──────────────────────────┘         └──────────────────────────┘

Next: Learn to build widgets like Text(), Button(), Container()!
```

- Creating app screens (widgets)
- Handling user input (buttons, forms)
- Managing app data (user info, settings)
- Making your app interactive and dynamic

**🚀 Great job! You now speak the basic language of programming!**
