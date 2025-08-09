# 🛠 Workshop 02: Development Environment Setup

## 🎯 Welcome to Professional Flutter Development!

This workshop will transform your computer into a powerful Flutter development machine. You'll set up professional-grade tools and configurations used by expert Flutter developers worldwide.

## 📋 Prerequisites
- Completion of Lesson 1 (Flutter basics)
- Administrator access to your computer
- Stable internet connection for downloads

## 🚀 Getting Started

### Step 1: Environment Verification
Let's first check your current Flutter setup:

```bash
# Create a verification script
mkdir flutter_env_setup
cd flutter_env_setup

# Check current Flutter status
flutter doctor -v > flutter_status.txt
flutter devices > devices_status.txt

# View the results
cat flutter_status.txt
cat devices_status.txt
```

**🎯 TODO**: Run these commands and note any issues in the output files.

### Step 2: Complete Flutter SDK Setup

If flutter doctor shows any issues, let's fix them systematically:

#### **Android Development Setup**
```bash
# Verify Android SDK
flutter config --android-sdk-path
echo $ANDROID_HOME

# If missing, download Android SDK via Android Studio
# Then set the path:
flutter config --android-sdk /path/to/android/sdk
```

#### **iOS Development Setup (macOS only)**
```bash
# Verify Xcode installation
xcode-select -p
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Accept licenses
sudo xcodebuild -license accept
```

#### **Web Development Setup**
```bash
# Enable web support (if not enabled)
flutter config --enable-web

# Verify Chrome is available
flutter config --web-browser chrome
```

### Step 3: IDE Optimization

#### **For VS Code Users**
Create a workspace configuration file:

```bash
# Create .vscode directory
mkdir -p .vscode

# We'll create settings.json in the next step
```

**🎯 TODO**: Copy the VS Code settings from the workshop guide and create your `.vscode/settings.json`.

#### **For Android Studio Users**
1. Install the Flutter plugin
2. Configure Dart SDK path
3. Set up code style preferences
4. Enable useful plugins

### Step 4: Create Development Shortcuts

#### **Shell Aliases**
Add these to your shell configuration file (.zshrc, .bashrc, etc.):

```bash
# Flutter shortcuts
alias fl='flutter'
alias flrun='flutter run'
alias fltest='flutter test'
alias flclean='flutter clean && flutter pub get'
alias flbuild='flutter build'

# Development helpers
alias fldevices='flutter devices'
alias fldoctor='flutter doctor'
alias flhot='flutter run --hot'
```

**🎯 TODO**: Add these aliases to your shell configuration and reload your terminal.

### Step 5: Project Template Setup

Create a Flutter project template with your preferred structure:

```bash
# Create a template project
flutter create flutter_template --org com.yourname

cd flutter_template

# Create common directories
mkdir -p lib/screens lib/widgets lib/models lib/services lib/utils
mkdir -p test/unit test/widget test/integration

# Create a basic folder structure documentation
echo "# Project Structure
lib/
├── screens/     # App screens/pages
├── widgets/     # Reusable UI components  
├── models/      # Data models
├── services/    # API and business logic
└── utils/       # Helper functions

test/
├── unit/        # Unit tests
├── widget/      # Widget tests
└── integration/ # Integration tests" > STRUCTURE.md
```

### Step 6: Quality Tools Setup

#### **Analysis Options**
Create a comprehensive analysis_options.yaml:

```bash
# Create analysis configuration
cat << 'EOF' > analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Dart Style
    camel_case_types: true
    camel_case_extensions: true
    file_names: true
    
    # Documentation
    public_member_api_docs: false
    
    # Design
    use_key_in_widget_constructors: true
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    
    # Performance
    avoid_unnecessary_containers: true
    avoid_print: true
    
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
EOF
```

#### **Git Configuration**
```bash
# Initialize git repository
git init

# Create comprehensive .gitignore
curl -o .gitignore https://raw.githubusercontent.com/flutter/flutter/master/.gitignore

# Initial commit
git add .
git commit -m "Initial project setup with Flutter template"
```

### Step 7: Performance Optimization

#### **Build Tools Optimization**
```bash
# Configure Gradle for faster builds (Android)
mkdir -p android
cat << 'EOF' > android/gradle.properties
org.gradle.jvmargs=-Xmx4g -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
org.gradle.parallel=true
org.gradle.configureondemand=true
org.gradle.daemon=true
android.useAndroidX=true
android.enableJetifier=true
android.enableR8=true
EOF
```

#### **VS Code Performance Settings**
```json
{
  "dart.maxLogLineLength": 2000,
  "dart.analysisServerFolding": false,
  "dart.previewCommitCharacters": false,
  "dart.triggerSignatureHelpAutomatically": false,
  "dart.completeFunctionCalls": false
}
```

### Step 8: Testing Your Setup

#### **Multi-Platform Test**
```bash
# Test web development
flutter create test_web_app
cd test_web_app
flutter run -d chrome

# Test mobile development  
flutter create test_mobile_app
cd test_mobile_app
flutter run # Should detect and run on available device

# Test hot reload
# Make a change to main.dart and save - should see instant update
```

#### **Development Workflow Test**
```bash
# Create a test project to verify complete workflow
flutter create workflow_test
cd workflow_test

# Add dependencies
flutter pub add provider http

# Run analysis
flutter analyze

# Run tests
flutter test

# Build for release
flutter build apk --split-per-abi
```

### Step 9: Advanced Configuration

#### **Custom Scripts**
Create useful development scripts:

```bash
# Create scripts directory
mkdir scripts

# Flutter project initialization script
cat << 'EOF' > scripts/init_flutter_project.sh
#!/bin/bash
PROJECT_NAME=$1
ORG_NAME=${2:-com.example}

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: ./init_flutter_project.sh <project_name> [org_name]"
    exit 1
fi

echo "Creating Flutter project: $PROJECT_NAME"
flutter create --org $ORG_NAME $PROJECT_NAME

cd $PROJECT_NAME

# Create directory structure
mkdir -p lib/{screens,widgets,models,services,utils}
mkdir -p test/{unit,widget,integration}

# Add common dependencies
flutter pub add provider http shared_preferences

# Create gitignore
curl -s -o .gitignore https://raw.githubusercontent.com/flutter/flutter/master/.gitignore

echo "Project $PROJECT_NAME created successfully!"
echo "Next steps:"
echo "  cd $PROJECT_NAME"
echo "  flutter run"
EOF

chmod +x scripts/init_flutter_project.sh
```

#### **Development Environment Script**
```bash
cat << 'EOF' > scripts/check_dev_env.sh
#!/bin/bash

echo "🔍 Flutter Development Environment Check"
echo "========================================"

echo -e "\n📱 Flutter Doctor:"
flutter doctor

echo -e "\n🎯 Available Devices:"
flutter devices

echo -e "\n⚙️  Flutter Configuration:"
flutter config

echo -e "\n📦 Global Packages:"
flutter pub global list

echo -e "\n✅ Environment check complete!"
EOF

chmod +x scripts/check_dev_env.sh
```

### Step 10: Troubleshooting Common Issues

#### **Permission Issues (macOS/Linux)**
```bash
# Fix Flutter permissions
sudo chown -R $(whoami) /path/to/flutter
```

#### **Android SDK Issues**
```bash
# Reset Android SDK path
flutter config --android-sdk /path/to/android/sdk

# Clear Flutter cache
flutter clean
flutter pub cache repair
```

#### **iOS Build Issues (macOS)**
```bash
# Reset iOS development setup
sudo xcode-select --reset
sudo xcodebuild -license accept
```

#### **Web Development Issues**
```bash
# Enable web support
flutter config --enable-web
flutter create . --platforms web
```

## 🎉 Verification Checklist

Confirm your setup is complete:

- [ ] `flutter doctor` shows all green checkmarks
- [ ] Can create new Flutter projects successfully
- [ ] Can run projects on at least 2 platforms
- [ ] Hot reload works consistently (< 1 second)
- [ ] Code analysis runs without errors
- [ ] IDE/editor has Flutter support configured
- [ ] Git is configured for Flutter projects
- [ ] Useful aliases and scripts are available
- [ ] Build tools are optimized for performance

## 🎯 Success Criteria

You've successfully completed the setup when you can:

### **Development Workflow**
- [ ] Create a new Flutter project in under 30 seconds
- [ ] Run the project on multiple platforms
- [ ] Make code changes and see hot reload instantly
- [ ] Run tests and analysis without issues

### **Productivity Features**
- [ ] Use keyboard shortcuts for common tasks
- [ ] Access Flutter documentation quickly
- [ ] Debug applications effectively
- [ ] Use Git for version control

### **Professional Tools**
- [ ] Code formatting works automatically
- [ ] Linting catches potential issues
- [ ] IDE provides helpful code completion
- [ ] Build optimization reduces compilation time

## 🆘 Need Help?

- **Installation Issues**: Refer to [workshop_02.md](/curriculum/modules/lesson_02/workshop_02) for detailed troubleshooting
- **Platform-Specific Problems**: Check the official Flutter documentation for your OS
- **IDE Configuration**: Review the IDE-specific setup guides
- **Performance Issues**: Run the environment check script to identify bottlenecks

## ➡️ What's Next?

Ready for [Lesson 03: Dart Fundamentals](../lesson_03/) where you'll master the language that powers Flutter!

## 🎉 Congratulations!

You now have a **professional-grade Flutter development environment** that will serve you throughout your Flutter journey. This setup will save you countless hours and make development a joy rather than a struggle.

**Happy coding! 🚀**