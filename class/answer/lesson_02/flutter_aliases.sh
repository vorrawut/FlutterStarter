#!/bin/bash
# ================================
# COMPREHENSIVE FLUTTER ALIASES
# ================================
# Add this to your .zshrc, .bashrc, or .bash_profile

# Core Flutter Commands
alias fl='flutter'
alias flv='flutter --version'
alias fld='flutter doctor'
alias fldv='flutter doctor -v'
alias flconfig='flutter config'

# Project Management
alias flcreate='flutter create'
alias flnew='flutter create --org com.yourcompany'
alias flpub='flutter pub'
alias flget='flutter pub get'
alias flupgrade='flutter pub upgrade'
alias floutdated='flutter pub outdated'

# Development Workflow
alias flrun='flutter run'
alias flrunhot='flutter run --hot'
alias flrunrelease='flutter run --release'
alias flrunprofile='flutter run --profile'
alias flattach='flutter attach'

# Platform-Specific Running
alias flios='flutter run -d ios'
alias flandroid='flutter run -d android'
alias flweb='flutter run -d chrome'
alias flmacos='flutter run -d macos'
alias flwindows='flutter run -d windows'
alias fllinux='flutter run -d linux'

# Building
alias flbuild='flutter build'
alias flbuildapk='flutter build apk'
alias flbuildios='flutter build ios'
alias flbuildweb='flutter build web'
alias flbuildmacos='flutter build macos'
alias flbuildwindows='flutter build windows'
alias flbuildlinux='flutter build linux'

# Advanced Build Commands
alias flbuildapksplit='flutter build apk --split-per-abi'
alias flbuildappbundle='flutter build appbundle'
alias flbuildipa='flutter build ipa'
alias flbuildwebrelease='flutter build web --release'

# Testing
alias fltest='flutter test'
alias fltestwatch='flutter test --watch'
alias fltestcov='flutter test --coverage'
alias fltestintegration='flutter test integration_test'
alias fldriver='flutter drive'

# Analysis and Quality
alias flanalyze='flutter analyze'
alias flformat='dart format .'
alias flformatcheck='dart format --dry-run .'
alias flfix='dart fix --apply'

# Cleaning and Maintenance
alias flclean='flutter clean'
alias flreset='flutter clean && flutter pub get'
alias flpubcache='flutter pub cache clean'
alias flpubrepair='flutter pub cache repair'

# Device Management
alias fldevices='flutter devices'
alias fldeviceslist='flutter devices --machine'
alias flemulators='flutter emulators'
alias flemulatorlaunch='flutter emulators --launch'

# Debugging and Profiling
alias fllogs='flutter logs'
alias flattachdev='flutter attach --debug'
alias flscreenshot='flutter screenshot'
alias flperformance='flutter run --profile'

# Installation and Global Packages
alias flglobal='flutter pub global'
alias flgloballist='flutter pub global list'
alias flglobalactivate='flutter pub global activate'
alias flglobaldeactivate='flutter pub global deactivate'

# DevTools
alias fldevtools='flutter pub global run devtools'
alias fldevtoolslaunch='dart devtools'

# Project Information
alias flchannels='flutter channel'
alias flswitchchannel='flutter channel'
alias flupgradechannel='flutter upgrade'

# Useful Combinations
alias flstart='flutter clean && flutter pub get && flutter run'
alias flrebuild='flutter clean && flutter pub get && flutter build apk'
alias flcheck='flutter doctor && flutter analyze && flutter test'

# Quick Project Setup
flquick() {
    if [ $# -eq 0 ]; then
        echo "Usage: flquick <project_name> [org_name]"
        return 1
    fi
    
    local project_name=$1
    local org_name=${2:-com.example}
    
    flutter create --org $org_name $project_name
    cd $project_name
    
    # Create common directories
    mkdir -p lib/{screens,widgets,models,services,utils}
    mkdir -p test/{unit,widget,integration}
    
    # Add common dependencies
    flutter pub add provider http shared_preferences
    
    echo "✅ Project $project_name created with common structure!"
    echo "📁 Created directories: screens, widgets, models, services, utils"
    echo "📦 Added packages: provider, http, shared_preferences"
    echo "🚀 Run 'flutter run' to start development"
}

# Flutter Environment Check
flcheck() {
    echo "🔍 Flutter Environment Check"
    echo "============================"
    
    echo -e "\n📱 Flutter Doctor:"
    flutter doctor
    
    echo -e "\n🎯 Available Devices:"
    flutter devices
    
    echo -e "\n📊 Flutter Configuration:"
    flutter config
    
    echo -e "\n📦 Global Packages:"
    flutter pub global list
    
    echo -e "\n✅ Check complete!"
}

# Flutter Performance Analysis
flperf() {
    if [ $# -eq 0 ]; then
        echo "Usage: flperf <dart_file>"
        echo "Example: flperf lib/main.dart"
        return 1
    fi
    
    local dart_file=$1
    
    echo "🚀 Running performance analysis for $dart_file"
    
    # Run with performance profiling
    flutter run --profile --trace-startup --dart-define=FLUTTER_ANALYZER_OPTIONS="--enable-experiment=non-nullable"
}

# Flutter Clean Install (Nuclear Option)
flnuke() {
    echo "🧹 Performing complete Flutter clean install..."
    
    # Clean everything
    flutter clean
    flutter pub cache clean
    
    # Remove build artifacts
    rm -rf build/
    rm -rf .dart_tool/
    rm -rf ios/Pods/
    rm -rf ios/.symlinks/
    rm -rf android/.gradle/
    
    # Reinstall dependencies
    flutter pub get
    
    # For iOS projects, clean pods
    if [ -d "ios" ]; then
        cd ios
        rm -rf Pods/
        rm -f Podfile.lock
        pod install
        cd ..
    fi
    
    echo "✅ Nuclear clean complete!"
}

# Flutter Dependencies Update
fldepupdate() {
    echo "📦 Updating Flutter dependencies..."
    
    # Show outdated packages
    echo "Current outdated packages:"
    flutter pub outdated
    
    # Update all dependencies
    flutter pub upgrade
    
    # Run pub get to ensure consistency
    flutter pub get
    
    echo "✅ Dependencies updated!"
}

# Flutter Hot Restart with Clean
flhotclean() {
    echo "🔥 Hot restart with clean..."
    flutter clean
    flutter pub get
    flutter run --hot
}

# Flutter Generate Icons and Splash
flicons() {
    echo "🎨 Generating app icons and splash screens..."
    
    # Generate icons
    if flutter pub deps | grep -q "flutter_launcher_icons"; then
        flutter pub run flutter_launcher_icons:main
    else
        echo "❌ flutter_launcher_icons not found. Add it to dev_dependencies."
    fi
    
    # Generate splash screens
    if flutter pub deps | grep -q "flutter_native_splash"; then
        flutter pub run flutter_native_splash:create
    else
        echo "❌ flutter_native_splash not found. Add it to dev_dependencies."
    fi
}

# Flutter Bundle Size Analysis
flsize() {
    echo "📊 Analyzing app bundle size..."
    
    # Build APK with size analysis
    flutter build apk --analyze-size
    
    # If available, use bundle tool
    if command -v bundletool.jar &> /dev/null; then
        echo "📱 Generating bundle size report..."
        bundletool.jar get-size total --apks=build/app/outputs/bundle/release/app-release.aab
    fi
}

# Flutter Code Generation
flgen() {
    echo "🔧 Running code generation..."
    
    # Run build_runner
    if flutter pub deps | grep -q "build_runner"; then
        flutter packages pub run build_runner build --delete-conflicting-outputs
    else
        echo "❌ build_runner not found. Add it to dev_dependencies for code generation."
    fi
}

# Flutter L10n Generation
fll10n() {
    echo "🌍 Generating localizations..."
    flutter gen-l10n
}

# Export aliases for usage outside of functions
export -f flquick flcheck flperf flnuke fldepupdate flhotclean flicons flsize flgen fll10n

echo "✅ Flutter aliases loaded! Type 'flcheck' to verify your environment."
echo "💡 Use 'flquick <project_name>' to quickly create a new project with common structure."