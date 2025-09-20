# 🍎 Flutter (Android Ready)


[Git Hub](https://github.com/vorrawut/FlutterStarter)
## 🎯 Lesson Goals

- Create Flutter project and run Flutter using Android device
- Install the Flutter SDK via Flutter Version Management (FVM)


---

## 🧾 Pre-requisite Checklist
| Requirement | How to check | If missing |
| --- | --- | --- |
| VS Code | `code --version` | https://code.visualstudio.com/  |
| Android Studio | Search 'Android Studio'  | https://developer.android.com/studio |
| Xcode | Search 'Xcode' | App store |
| Homebrew | `brew --version` | If not found, run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` |


---

## 🦖 Flutter SDK Installation — Manual Download

[ Manual Install Flutter SDK ](https://docs.flutter.dev/install/manual)

1. **Create a directory and download the SDK**

   ```bash
   mkdir -p ~/development && cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_latest.zip
   unzip flutter_macos_arm64_latest.zip
   ```

2. **Add Flutter to PATH**
   ```bash
   code ~/.zshrc
   ```
   ```
   export PATH="$HOME/development/flutter/bin:$PATH"
   ```

3. **Verify installation**
   ```bash
   flutter --version
   ```

---

## 🦾 Flutter SDK Installation — Using FVM (Flutter Version Management)

1. **Install FVM**
   ```bash
   brew tap leoafarias/fvm
   brew install fvm
   fvm
   ```

   ```
   fvm releases - View all Flutter SDK releases available for install.
   fvm install - Installs Flutter SDK Version.
   fvm use - Sets Flutter SDK Version you would like to use in a project.
   fvm global - Sets Flutter SDK Version as a global.
   ```

2. **Install Flutter**
   ```bash
   fvm install 3.35.0 
   fvm global 3.35.0          
   ```

---

## Create and Run Your First Project
```bash
mkdir myFlutterProject
fvm flutter create pokedex --platforms android,ios, web
cd pokedex
```
Pick your emulator or physical device when prompted.

Handy commands for day-to-day work:
```bash
flutter devices          # List connected devices and emulators
flutter clean            # Clear build cache when odd issues appear
flutter pub get          # Fetch dependencies
flutter upgrade          # Update Flutter if you installed it directly
fvm flutter upgrade      # Update when using FVM
```

## 👾 Run Flutter
```bash
flutter doctor
```
Aim for green check marks on every line, especially:
- **Android toolchain**
- **Android Studio**
- **Connected device** (emulator or physical phone)

If you see something like `Android toolchain - develop for Android devices (✗) Unable to locate Android SDK or Java`, continue to the next section.

```bash
flutter run
```
---

## Fixing the “Android toolchain missing JDK” Warning with SDKMAN!
1. **Install SDKMAN!**
   ```bash
   curl -s "https://get.sdkman.io" | bash
   source "$HOME/.sdkman/bin/sdkman-init.sh"
   echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.zshrc
   ```

2. **Install JDK 11 (recommended: Zulu 11)**
   ```bash
   sdk install java 11.0.22-zulu
   sdk default java 11.0.22-zulu
   java -version
   ```

3. **Re-run doctor**
   ```bash
   flutter doctor
   ```
   The Android toolchain line should now display a ✔️.

> SDKMAN! can also manage other SDKs (Gradle, Kotlin, Dart, etc.) if you ever need them.
