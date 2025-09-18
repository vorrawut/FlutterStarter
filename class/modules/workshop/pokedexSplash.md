# Pokedex Splash Screen

## 📋 What you'll learn

In this workshop, you'll learn how to create splash screen by using image asset or animation. This workshop covers essential Flutter concepts including:

- **Flutter App Build Lifecycle**
- **Add asset and image**
- **Setup time duration before navigate to other screen**

### 🎨 What We're Building

An animated splash screen that shows a Lottie Pokéball and then navigates to the Login screen after a short delay.

<video src="./images/splash/splash_screen.mp4" width=50% controls></video>

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

### **📁 Step 1: App entry and initial route**

Set the initial route to splash in your app root.

File: `class/pokedex/lib/main.dart`

```dart
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

File: `class/pokedex/lib/features/splash/splash_screen.dart`

```dart
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
    return Container();
  }
}
```

Decorate the screen with gradient

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
        child: SafeArea(
          child: Center(
            child: Text('Splash screen'),
          ),
        ),
      ),
    );
  }
```

### **📁 Step 3: Ensure assets and packages are configured**

In the Pokedex sample app, Lottie and assets are already configured:

File: `class/pokedex/pubspec.yaml`

```yaml
dependencies:
  lottie: ^3.3.2

flutter:
  assets:
    - assets/
```

https://pub.dev/packages/lottie

Place your animation file at `class/pokedex/assets/pokeball_animation.json`

```dart
SizedBox(
    child: Lottie.asset('assets/pokeball_animation.json'),
)
```

### **📁 Step 4: Navigate to the next screen**

Use `pushReplacementNamed` to move from splash to login without keeping splash in the back stack.

```dart
@override
void initState() {
    super.initState();
    _navigateNext()
}

Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.login);
}
```

Tips:

- Replace the delay with real initialization (e.g., check auth token, load config, warm up services). Navigate to different routes based on results.
- Keep `build` purely UI; trigger async work from `initState` via a separate method.

---

### 🧩 Optional: Add a true native splash (before Flutter renders)

If you want an instant splash during engine startup, use `flutter_native_splash` in the Pokedex app:

File: `class/pokedex/pubspec.yaml`

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

Then run in the `class/pokedex` directory:

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
