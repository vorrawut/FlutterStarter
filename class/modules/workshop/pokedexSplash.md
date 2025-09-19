# Pokedex Splash Screen

## 📋 What you'll learn

In this workshop, you'll learn how to create splash screen by using image asset or animation. This workshop covers essential Flutter concepts including:

- **Flutter App Build Lifecycle**
- **Add asset and image**
- **Setup time duration before navigate to other screen**

### 🎨 What We're Building

An animated splash screen that shows a Lottie Pokéball and then navigates to the Login screen after a short delay.

<p align="center">
  <video
    src={require('./images/splash/splash_screen.mp4').default}
    controls
    playsInline
    style={{ width: '40%', borderRadius: 8 }}
  >
    Your browser does not support the video tag.
  </video>
</p>

<p align="center">
  <a href={require('./images/splash/splash_screen.mp4').default}>Open the video</a>
  <span style={{ opacity: 0.7 }}>(fallback link)</span>
</p>

### 🔄 Flutter App Build Lifecycle

This is the sequence from app launch until your splash completes:

```
        ┌───────────────────────────────┐
        │      User taps app icon       │
        └──────────────┬───── ──────────┘
                       │
                       ▼
        ┌───────────────────────────────┐
        │   Native Launch (OS screen)   │ -> Load Native Splash Screen
        └──────────────┬──────────── ───┘
                       │
                       ▼
        ┌───────────────────────────────┐
        │      Flutter Engine Init      │ -> Load dart VM and assets
        └──────────────┬───── ──────────┘
                       │
                       ▼
        ┌───────────────────────────────┐
        │   main.dart: runApp(...)      │ -> Build root widget and start widget tree
        └──────────────┬─ ──────────────┘
                       │
                       ▼
        ┌───────────────────────────────┐
        │       First Frame Render      │
        │          → SplashScreen       │
        └──────────────┬────── ─────────┘
                       │
                       ▼
        ┌───────────────────────────────┐
        │  Next screen? (decision)      │
        │  Login or Home/List           │
        └──────────────┬────────── ─────┘
                       │
              ┌────────┴────────┐
              ▼                 ▼
   ┌───────────────────┐   ┌─────────────────────┐
   │  Navigate: Login  │   │ Navigate: Home/List │
   └───────────────────┘   └─────────────────────┘
```

## Before you start

- Flutter SDK installed and `flutter run` works on your machine.
- This starter app (or any Flutter project where you can add a new screen).
- Internet access to `https://pokeapi.co`.
- A text editor or IDE with Dart/Flutter plugins enabled.

If you are unsure, run `flutter --version` in a terminal. Seeing version information confirms your setup works.

---

### **📁 Step 1a: Create route constants**

First, let's define all the route paths in a constants file.

**Create** `/lib/core/constants/routes.dart`
```dart
class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String pokemonList = '/pokemon-list';
  static const String pokemonDetail = '/pokemon-detail';

  static List<String> get allRoutes => [
    splash,
    login,
    pokemonList,
    pokemonDetail,
  ];
}
```

### **📁 Step 1b: Create navigation route generator**

Now create the route generator that will handle navigation between screens.

**Create** `/lib/core/navigation/route_generator.dart`
```dart
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../../features/splash/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _createRoute(const SplashScreen());

      default:
        return _createRoute(const SplashScreen());
    }
  }

  static PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
```

### **📁 Step 1c: Update main.dart to use routing**

Now update your app entry point to use the routing system.

**Update** `/lib/main.dart`
```dart
import 'package:flutter/material.dart';
import 'core/constants/routes.dart';
import 'core/navigation/route_generator.dart';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC107),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      initialRoute: Routes.splash,           // Points to '/'
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
```


### **📁 Step 2: Create the SplashScreen widget**

We use a StatefulWidget to start a delay (or async init) and then navigate.

**Create** `/lib/features/splash/splash_screen.dart`

```dart
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash screen'),
      ),
    );
  }
}
```

Now let's add a beautiful gradient background to the splash screen:

**Update** the `build` method in your `SplashScreen`:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1B2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Splash screen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}
```

### **📁 Step 3: Ensure assets and packages are configured**

In the Pokedex sample app, Lottie and assets are already configured:

File: `pubspec.yaml`

```yaml
dependencies:
  lottie: ^3.3.2

flutter:
  assets:
    - assets/
```

https://pub.dev/packages/lottie

Place your animation file at `/assets/pokeball_animation.json`

Now update your SplashScreen to use the Lottie animation. First, **add the import** at the top of your SplashScreen file:

```dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';  // Add this import
```

Then **replace the Text widget** in your build method with the Lottie animation:

```dart
child: Center(
  child: SizedBox(
    height: 150,
    width: 150,
    child: Lottie.asset('assets/pokeball_animation.json'),
  ),
),
```

### **📁 Step 4a: Create the LoginScreen**

Before we can navigate to the login screen, let's create it first.

**Create** `/lib/features/login/login_screen.dart`
```dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
      ),
    );
  }
}
```

### **📁 Step 4b: Update route generator to handle login**

Now update the route generator to include the login route.

**Update** `/lib/core/navigation/route_generator.dart`
```dart
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/login/login_screen.dart';  // Add this import

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _createRoute(const SplashScreen());

      case Routes.login:
        return _createRoute(const LoginScreen());  // Add this case

      default:
        return _createRoute(const SplashScreen());
    }
  }

  static PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
```

### **📁 Step 4c: Add navigation from splash to login**

Finally, add the navigation logic to your SplashScreen to move to the login screen after a delay.

**Update** the `SplashScreen` in `/lib/features/splash/splash_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/routes.dart';  // Add this import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();  // Add this call
  }

  Future<void> _navigateNext() async {
    // Wait for 3 seconds to show the splash animation
    await Future.delayed(const Duration(milliseconds: 3000));
    
    // Check if the widget is still mounted before navigating
    if (!mounted) return;
    
    // Navigate to login screen and remove splash from back stack
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1B2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SizedBox(
              height: 150,
              width: 150,
              child: Lottie.asset('assets/pokeball_animation.json'),
            ),
          ),
        ),
      ),
    );
  }
}
```


Tips:

- Replace the delay with real initialization (e.g., check auth token, load config, warm up services). Navigate to different routes based on results.
- Keep `build` purely UI; trigger async work from `initState` via a separate method.

---

### 🧩 Optional: Add a true native splash (before Flutter renders)

If you want an instant splash during engine startup, use `flutter_native_splash` in the Pokedex app:

File: `pubspec.yaml`

```yaml
dev_dependencies:
  flutter_native_splash: ^2.4.1

flutter_native_splash:
  color: "#1A1B2E" # Match your Flutter splash background
  image: assets/pokeball.png # Optional centered image
  android_12:
    color: "#1A1B2E"
    image: assets/pokeball.png
```

Then run in the main directory:

```bash
flutter pub get
dart run flutter_native_splash:create
```

Best practice: match the native splash background/image to your Flutter splash to avoid a visual “flash” when transitioning.

---

### 🧠 Quick recap

- App launch → `main()` → `runApp()` → `MaterialApp(initialRoute: '/')` → navigates to `SplashScreen` via route generator
- In `SplashScreen.initState()`, start initialization or a short delay (via a separate async method) while `build()` renders the splash animation/UI
- When initialization completes → `Navigator.pushReplacementNamed(context, Routes.login)` to navigate and remove splash from back stack → `dispose()` runs
- Note: If authentication is involved, branch the next route (Login vs Home/List) inside the navigation method

That’s the minimal and clean pattern for a Flutter splash screen.
