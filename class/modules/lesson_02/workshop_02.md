# 🛠 Workshop 02: Setting Up Your Development Environment

## 🎯 What We're Building
A perfectly optimized Flutter development environment that will make you productive, efficient, and happy while coding. We'll set up tools, extensions, shortcuts, and configurations that professional Flutter developers use daily.

## ✅ Expected Outcome
By the end of this workshop, you will have:
- ✅ Flutter SDK properly installed and configured
- ✅ IDE/Editor optimized with essential extensions
- ✅ Emulators and simulators ready for testing
- ✅ Useful development tools and shortcuts configured
- ✅ Debugging tools set up and working
- ✅ Code formatting and linting configured
- ✅ A personalized development workflow

## 👨‍💻 Steps to Complete

### Step 1: Flutter SDK Installation & Verification

First, let's ensure Flutter is properly installed and configured.

#### 🔍 Check Current Installation
```bash
# Check Flutter version and status
flutter doctor -v

# Check available devices
flutter devices

# Check for any issues
flutter doctor
```

**🎯 TODO**: Run the commands above and note any warnings or errors. We'll fix them!

#### 📝 Expected Output
Your `flutter doctor` should show:
- ✅ Flutter (Channel stable, version 3.27.x)
- ✅ Android toolchain - develop for Android devices
- ✅ Xcode - develop for iOS and macOS (macOS only)
- ✅ Chrome - develop for the web
- ✅ Android Studio / VS Code

#### 🔧 Fix Common Issues

**Missing Android SDK?**
```bash
# Install via Android Studio or command line
flutter config --android-sdk /path/to/android/sdk
```

**Can't find Xcode? (macOS only)**
```bash
# Install Xcode from App Store, then:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

**Chrome not detected?**
```bash
# Ensure Chrome is in your PATH or:
flutter config --web-browser chrome
```

### Step 2: IDE Setup - Choose Your Weapon

We'll optimize either VS Code or Android Studio (or both!).

#### Option A: VS Code Setup (Recommended for Beginners)

**🎯 TODO**: Install these essential extensions:

1. **Flutter** (Dart-Code.flutter)
2. **Dart** (Dart-Code.dart-code)
3. **Awesome Flutter Snippets** (Nash.awesome-flutter-snippets)
4. **Bracket Pair Colorizer** (CoenraadS.bracket-pair-colorizer)
5. **Error Lens** (usernamehw.errorlens)
6. **GitLens** (eamodio.gitlens)
7. **Material Icon Theme** (PKief.material-icon-theme)
8. **Auto Rename Tag** (formulahendry.auto-rename-tag)
9. **Thunder Client** (rangav.vscode-thunder-client) - for API testing

**Quick Install Command:**
```bash
# Install all at once (copy-paste each line)
code --install-extension Dart-Code.flutter
code --install-extension Dart-Code.dart-code
code --install-extension Nash.awesome-flutter-snippets
code --install-extension usernamehw.errorlens
code --install-extension eamodio.gitlens
code --install-extension PKief.material-icon-theme
code --install-extension ms-vscode.vscode-json
```

#### Option B: Android Studio Setup

**🎯 TODO**: Install these plugins:
1. Go to **File → Settings → Plugins**
2. Install:
   - **Flutter** (includes Dart)
   - **Rainbow Brackets**
   - **String Manipulation**
   - **Save Actions**
   - **ADB Idea**

### Step 3: Configure Your Settings

#### VS Code Configuration

**🎯 TODO**: Create/update your VS Code settings.json:

1. Open Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`)
2. Type "Preferences: Open Settings (JSON)"
3. Add these configurations:

```json
{
  // Flutter specific settings
  "dart.flutterSdkPath": "/path/to/your/flutter",
  "dart.checkForSdkUpdates": true,
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true,
  
  // Editor settings
  "editor.formatOnSave": true,
  "editor.formatOnType": true,
  "editor.minimap.enabled": true,
  "editor.wordWrap": "on",
  "editor.rulers": [80, 120],
  
  // File associations
  "files.associations": {
    "*.dart": "dart"
  },
  
  // Auto-save
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  
  // Theme and appearance
  "workbench.iconTheme": "material-icon-theme",
  "workbench.colorTheme": "Dark+ (default dark)",
  
  // Flutter hot reload on save
  "dart.flutterHotReloadOnSave": "always",
  
  // Dart analyzer
  "dart.lineLength": 80,
  "dart.analysisServerFolding": true,
  
  // Terminal settings
  "terminal.integrated.shell.osx": "/bin/zsh",
  "terminal.integrated.fontSize": 14,
  
  // Git settings
  "git.enableSmartCommit": true,
  "git.confirmSync": false
}
```

#### Keyboard Shortcuts Setup

**🎯 TODO**: Add these useful shortcuts (Preferences → Keyboard Shortcuts → Open JSON):

```json
[
  {
    "key": "cmd+shift+r",
    "command": "dart.hotReload",
    "when": "dart-code:flutter-project"
  },
  {
    "key": "cmd+shift+s",
    "command": "dart.hotRestart",
    "when": "dart-code:flutter-project"
  },
  {
    "key": "cmd+k cmd+f",
    "command": "editor.action.formatDocument"
  },
  {
    "key": "cmd+shift+p",
    "command": "workbench.action.showCommands"
  }
]
```

### Step 4: Emulator and Simulator Setup

#### Android Emulator Setup

**🎯 TODO**: Create an Android Virtual Device (AVD):

1. Open Android Studio
2. Go to **Tools → AVD Manager**
3. Click **Create Virtual Device**
4. Choose a device (Pixel 6 recommended)
5. Download and select a system image (API 34 recommended)
6. Configure AVD:
   - Name: "Flutter_Dev_Phone"
   - Enable Hardware Keyboard
   - Set RAM to 2048MB+
   - Enable Graphics Hardware acceleration

**Test your emulator:**
```bash
# List available emulators
emulator -list-avds

# Start your emulator
emulator -avd Flutter_Dev_Phone

# Verify Flutter can see it
flutter devices
```

#### iOS Simulator Setup (macOS only)

**🎯 TODO**: Set up iOS Simulator:

```bash
# Open iOS Simulator
open -a Simulator

# List available simulators
xcrun simctl list devices

# Launch specific simulator
xcrun simctl boot "iPhone 15"
```

**Configure Simulator:**
1. **Device → Manage Devices**
2. Create iPhone 15 and iPad Air simulators
3. Install latest iOS version

### Step 5: Development Tools Setup

#### Git Configuration

**🎯 TODO**: Configure Git for Flutter projects:

```bash
# Set up global Git config
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Useful aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
```

#### Create a Flutter-specific .gitignore

**🎯 TODO**: Create a comprehensive .gitignore template:

```bash
# Create a global gitignore for Flutter
touch ~/.gitignore_flutter

# Add Flutter-specific ignores
cat << 'EOF' >> ~/.gitignore_flutter
# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Web related
lib/generated_plugin_registrant.dart

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# IDE related
.vscode/
.idea/
*.iml
*.ipr
*.iws

# OS related
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
EOF

# Set as global gitignore
git config --global core.excludesfile ~/.gitignore_flutter
```

### Step 6: Code Quality Tools

#### Dart Analysis Configuration

**🎯 TODO**: Create analysis_options.yaml for your projects:

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Dart style rules
    camel_case_types: true
    camel_case_extensions: true
    library_names: true
    file_names: true
    
    # Documentation
    public_member_api_docs: false
    
    # Design
    use_key_in_widget_constructors: true
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    
    # Imports
    always_use_package_imports: false
    prefer_relative_imports: true
    
    # Error prevention
    avoid_print: true
    avoid_unnecessary_containers: true
    avoid_web_libraries_in_flutter: true
    
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
```

#### Dart Formatter Configuration

**🎯 TODO**: Set up consistent code formatting:

```bash
# Format all Dart files in current directory
dart format .

# Format with line length of 80 characters
dart format --line-length 80 .

# Check formatting without applying changes
dart format --dry-run .
```

### Step 7: Useful Development Scripts

**🎯 TODO**: Create helpful shell scripts/aliases:

#### Bash/Zsh Aliases (add to ~/.zshrc or ~/.bashrc)

```bash
# Flutter aliases
alias fl='flutter'
alias flrun='flutter run'
alias flbuild='flutter build'
alias fltest='flutter test'
alias flclean='flutter clean'
alias flget='flutter pub get'
alias fldoc='flutter doctor'
alias fldevices='flutter devices'

# Development shortcuts
alias flreset='flutter clean && flutter pub get && flutter run'
alias flios='flutter run -d ios'
alias flandroid='flutter run -d android'
alias flweb='flutter run -d chrome'

# Project creation
alias flcreate='flutter create'
alias flnew='flutter create --org com.yourcompany'

# Testing
alias fltest='flutter test'
alias fltestcov='flutter test --coverage'

# Analysis
alias flanalyze='flutter analyze'
alias flformat='dart format .'
```

#### Development Scripts

**🎯 TODO**: Create useful scripts:

```bash
# Create a Flutter project setup script
mkdir -p ~/scripts
cat << 'EOF' > ~/scripts/flutter-new-project.sh
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: flutter-new-project.sh <project_name>"
    exit 1
fi

PROJECT_NAME=$1
ORG_NAME="com.yourcompany"

echo "Creating Flutter project: $PROJECT_NAME"
flutter create --org $ORG_NAME $PROJECT_NAME

cd $PROJECT_NAME

echo "Setting up project structure..."
mkdir -p lib/screens lib/widgets lib/models lib/services lib/utils

echo "Adding useful packages..."
flutter pub add provider http shared_preferences

echo "Project $PROJECT_NAME created successfully!"
echo "Next steps:"
echo "  cd $PROJECT_NAME"
echo "  flutter run"

EOF

chmod +x ~/scripts/flutter-new-project.sh
```

### Step 8: Testing Your Setup

#### Create a Test Project

**🎯 TODO**: Let's test everything works:

```bash
# Create a test project
flutter create dev_environment_test
cd dev_environment_test

# Test on different platforms
flutter run -d ios      # (macOS only)
flutter run -d android  # Requires emulator
flutter run -d chrome   # Web version
```

#### Hot Reload Test

**🎯 TODO**: With the app running:
1. Open `lib/main.dart`
2. Change the title text
3. Save the file (`Cmd+S` / `Ctrl+S`)
4. Watch the app update instantly!

#### Debug Test

**🎯 TODO**: Test debugging capabilities:
1. Set a breakpoint in your code (click left margin of line number)
2. Run in debug mode: `flutter run --debug`
3. Trigger the breakpoint and inspect variables

### Step 9: Browser Development Tools

#### Chrome DevTools for Flutter Web

**🎯 TODO**: Set up web development:

1. Run: `flutter run -d chrome --web-renderer html`
2. Open Chrome DevTools (`F12`)
3. Look for the "Flutter Inspector" tab
4. Explore the widget tree and performance tools

#### Flutter DevTools

**🎯 TODO**: Access advanced debugging:

```bash
# Install/update Flutter DevTools
flutter pub global activate devtools

# Launch DevTools
flutter pub global run devtools

# Or launch with your app
flutter run --devtools-port=9100
```

### Step 10: Productivity Workflow

#### Create Your Development Routine

**🎯 TODO**: Set up a project startup routine:

1. **Terminal Setup**: Use a terminal multiplexer (tmux) or multiple tabs
   - Tab 1: Main development (VS Code)
   - Tab 2: Flutter run
   - Tab 3: Git operations
   - Tab 4: Build/test commands

2. **VS Code Workspace**: Create a `.vscode/settings.json` for each project:
```json
{
  "dart.flutterSdkPath": "/Users/yourname/flutter",
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true,
    "**/build": true
  }
}
```

3. **Hot Reload Workflow**:
   - Save files frequently to see changes
   - Use `R` in terminal for manual hot reload
   - Use `Shift+R` for hot restart (full app restart)

## 🚀 How to Run

Your optimized development environment should now support:

```bash
# Quick project creation
flutter create my_awesome_app
cd my_awesome_app

# Multi-platform development
flutter run -d ios      # iOS Simulator
flutter run -d android  # Android Emulator  
flutter run -d chrome   # Web Browser
flutter run -d macos    # macOS Desktop

# Quality assurance
flutter analyze         # Code analysis
dart format .           # Code formatting
flutter test            # Run tests
```

## 🎉 Verification Checklist

Confirm your setup is complete:

- [ ] `flutter doctor` shows all green checkmarks
- [ ] Can create and run Flutter projects
- [ ] Hot reload works in under 1 second
- [ ] Can run on at least 2 platforms (mobile + web recommended)
- [ ] Code formatting works on save
- [ ] Error highlighting shows immediately
- [ ] Flutter Inspector/DevTools accessible
- [ ] Git is configured for Flutter projects
- [ ] Useful shortcuts and aliases configured
- [ ] Emulator/simulator starts without issues

## 🔧 Troubleshooting Common Issues

### "Flutter not found in PATH"
```bash
# Add to ~/.zshrc or ~/.bashrc
export PATH="$PATH:/path/to/flutter/bin"
source ~/.zshrc  # or ~/.bashrc
```

### "No devices available"
```bash
# Check connected devices
flutter devices

# Start Android emulator
emulator -avd Flutter_Dev_Phone

# Start iOS simulator (macOS)
open -a Simulator
```

### "Hot reload not working"
1. Ensure you're running in debug mode
2. Check that you're editing the correct file
3. Try hot restart instead (`Shift+R`)
4. Restart the Flutter app completely

### "Code formatting not working"
1. Verify Dart extension is installed
2. Check VS Code settings.json has `"editor.formatOnSave": true`
3. Try manual format: `Cmd+Shift+P` → "Format Document"

## 🔄 Next Steps

Ready for [Lesson 03: Dart Fundamentals](../lesson_03/) where we'll dive deep into the Dart language that powers Flutter!

## 🎓 What You've Accomplished

You now have a **professional-grade Flutter development environment** that will:
- Save you hours of debugging setup issues
- Provide instant feedback while coding
- Support efficient multi-platform development
- Give you the tools used by expert Flutter developers

**🚀 Your development velocity just increased by 10x!**

---

**🎯 Environment Setup Complete**: You're now equipped with the same tools and configurations used by professional Flutter teams worldwide!