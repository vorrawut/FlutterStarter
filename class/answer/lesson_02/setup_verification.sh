#!/bin/bash

# ================================
# FLUTTER DEVELOPMENT ENVIRONMENT VERIFICATION SCRIPT
# ================================
# This script verifies that your Flutter development environment is optimally configured

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Emojis for better UX
CHECK="✅"
CROSS="❌"
WARNING="⚠️"
INFO="ℹ️"

echo -e "${BLUE}🚀 Flutter Development Environment Verification${NC}"
echo "=================================================="
echo

# Function to check command existence
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Flutter version
check_flutter_version() {
    if command_exists flutter; then
        echo -e "${INFO} Flutter Installation:"
        local flutter_version=$(flutter --version | head -n 1)
        echo "  $flutter_version"
        
        # Check if it's a stable version
        if echo $flutter_version | grep -q "stable"; then
            echo -e "  ${CHECK} Flutter is on stable channel"
        else
            echo -e "  ${WARNING} Flutter is not on stable channel"
        fi
        echo
    else
        echo -e "${CROSS} Flutter is not installed or not in PATH"
        echo
        return 1
    fi
}

# Function to check Flutter doctor
check_flutter_doctor() {
    echo -e "${INFO} Running Flutter Doctor:"
    echo "=========================="
    
    # Run flutter doctor and capture output
    flutter doctor > /tmp/flutter_doctor.txt 2>&1
    
    # Display the output
    cat /tmp/flutter_doctor.txt
    echo
    
    # Check for issues
    if grep -q "No issues found!" /tmp/flutter_doctor.txt; then
        echo -e "${CHECK} No issues found with Flutter installation!"
    else
        echo -e "${WARNING} Some issues found. Please review the output above."
    fi
    echo
}

# Function to check available devices
check_devices() {
    echo -e "${INFO} Available Devices:"
    echo "==================="
    
    local devices=$(flutter devices 2>/dev/null)
    
    if echo "$devices" | grep -q "No devices"; then
        echo -e "${CROSS} No devices available for testing"
        echo "  Please set up at least one device (emulator, simulator, or physical device)"
    else
        echo "$devices"
        
        # Count available devices
        local device_count=$(echo "$devices" | grep -c "•")
        echo
        echo -e "${CHECK} Found $device_count available device(s)"
    fi
    echo
}

# Function to check IDE setup
check_ide_setup() {
    echo -e "${INFO} IDE Configuration Check:"
    echo "=========================="
    
    # Check for VS Code
    if command_exists code; then
        echo -e "${CHECK} VS Code is installed"
        
        # Check for Flutter extension
        if code --list-extensions | grep -q "dart-code.flutter"; then
            echo -e "${CHECK} Flutter extension for VS Code is installed"
        else
            echo -e "${CROSS} Flutter extension for VS Code is NOT installed"
            echo "  Install it with: code --install-extension dart-code.flutter"
        fi
    else
        echo -e "${INFO} VS Code not found in PATH"
    fi
    
    # Check for Android Studio
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [ -d "/Applications/Android Studio.app" ]; then
            echo -e "${CHECK} Android Studio is installed (macOS)"
        else
            echo -e "${INFO} Android Studio not found in /Applications/"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists studio || command_exists android-studio; then
            echo -e "${CHECK} Android Studio is installed (Linux)"
        else
            echo -e "${INFO} Android Studio not found in PATH"
        fi
    fi
    echo
}

# Function to check development tools
check_dev_tools() {
    echo -e "${INFO} Development Tools:"
    echo "==================="
    
    # Check Git
    if command_exists git; then
        local git_version=$(git --version)
        echo -e "${CHECK} Git: $git_version"
    else
        echo -e "${CROSS} Git is not installed"
    fi
    
    # Check Dart
    if command_exists dart; then
        local dart_version=$(dart --version 2>&1 | head -n 1)
        echo -e "${CHECK} Dart: $dart_version"
    else
        echo -e "${CROSS} Dart is not installed or not in PATH"
    fi
    
    # Check Platform-specific tools
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS specific checks
        if command_exists xcodebuild; then
            echo -e "${CHECK} Xcode command line tools are installed"
        else
            echo -e "${CROSS} Xcode command line tools are NOT installed"
            echo "  Install with: xcode-select --install"
        fi
        
        if command_exists pod; then
            local pod_version=$(pod --version)
            echo -e "${CHECK} CocoaPods: $pod_version"
        else
            echo -e "${WARNING} CocoaPods is not installed (needed for iOS dependencies)"
            echo "  Install with: sudo gem install cocoapods"
        fi
    fi
    
    # Check Chrome for web development
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [ -d "/Applications/Google Chrome.app" ]; then
            echo -e "${CHECK} Google Chrome is installed"
        else
            echo -e "${WARNING} Google Chrome not found (needed for web development)"
        fi
    elif command_exists google-chrome || command_exists chromium-browser; then
        echo -e "${CHECK} Chrome/Chromium is installed"
    else
        echo -e "${WARNING} Chrome not found (needed for web development)"
    fi
    echo
}

# Function to check Flutter configuration
check_flutter_config() {
    echo -e "${INFO} Flutter Configuration:"
    echo "======================="
    
    # Check enabled platforms
    local config=$(flutter config 2>/dev/null)
    
    if echo "$config" | grep -q "enable-web: true"; then
        echo -e "${CHECK} Web development is enabled"
    else
        echo -e "${WARNING} Web development is disabled"
        echo "  Enable with: flutter config --enable-web"
    fi
    
    if echo "$config" | grep -q "enable-linux-desktop: true"; then
        echo -e "${CHECK} Linux desktop development is enabled"
    else
        echo -e "${INFO} Linux desktop development is disabled (optional)"
    fi
    
    if echo "$config" | grep -q "enable-macos-desktop: true"; then
        echo -e "${CHECK} macOS desktop development is enabled"
    else
        echo -e "${INFO} macOS desktop development is disabled (optional)"
    fi
    
    if echo "$config" | grep -q "enable-windows-desktop: true"; then
        echo -e "${CHECK} Windows desktop development is enabled"
    else
        echo -e "${INFO} Windows desktop development is disabled (optional)"
    fi
    echo
}

# Function to check global packages
check_global_packages() {
    echo -e "${INFO} Global Dart Packages:"
    echo "======================"
    
    local global_packages=$(flutter pub global list 2>/dev/null)
    
    if echo "$global_packages" | grep -q "devtools"; then
        echo -e "${CHECK} DevTools is installed globally"
    else
        echo -e "${WARNING} DevTools is not installed globally"
        echo "  Install with: flutter pub global activate devtools"
    fi
    
    if echo "$global_packages" | grep -q "stagehand"; then
        echo -e "${CHECK} Stagehand is installed globally"
    else
        echo -e "${INFO} Stagehand is not installed (optional project generator)"
    fi
    
    if echo "$global_packages" | grep -q "flutter_launcher_icons"; then
        echo -e "${CHECK} Flutter Launcher Icons is installed globally"
    else
        echo -e "${INFO} Flutter Launcher Icons is not installed globally (optional)"
    fi
    echo
}

# Function to test project creation
test_project_creation() {
    echo -e "${INFO} Testing Project Creation:"
    echo "=========================="
    
    local test_dir="/tmp/flutter_test_$(date +%s)"
    
    # Create test project
    if flutter create "$test_dir" --quiet > /dev/null 2>&1; then
        echo -e "${CHECK} Successfully created test project"
        
        # Try to get dependencies
        cd "$test_dir"
        if flutter pub get > /dev/null 2>&1; then
            echo -e "${CHECK} Successfully downloaded dependencies"
        else
            echo -e "${CROSS} Failed to download dependencies"
        fi
        
        # Clean up
        cd - > /dev/null
        rm -rf "$test_dir"
    else
        echo -e "${CROSS} Failed to create test project"
    fi
    echo
}

# Function to check performance settings
check_performance() {
    echo -e "${INFO} Performance Settings:"
    echo "======================"
    
    # Check system resources
    if [[ "$OSTYPE" == "darwin"* ]]; then
        local ram=$(sysctl hw.memsize | awk '{print int($2/1024/1024/1024)}')
        echo "  System RAM: ${ram}GB"
        
        if [ "$ram" -ge 8 ]; then
            echo -e "${CHECK} Sufficient RAM for Flutter development"
        else
            echo -e "${WARNING} Consider upgrading RAM for better performance"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        local ram=$(free -g | awk '/^Mem:/{print $2}')
        echo "  System RAM: ${ram}GB"
        
        if [ "$ram" -ge 8 ]; then
            echo -e "${CHECK} Sufficient RAM for Flutter development"
        else
            echo -e "${WARNING} Consider upgrading RAM for better performance"
        fi
    fi
    
    # Check available disk space
    local available_space=$(df -h . | awk 'NR==2{print $4}')
    echo "  Available disk space: $available_space"
    echo
}

# Function to generate summary report
generate_summary() {
    echo -e "${BLUE}📋 Summary Report${NC}"
    echo "================="
    echo
    
    # Count issues
    local issues=0
    
    # Basic checks
    if ! command_exists flutter; then
        echo -e "${CROSS} Flutter is not installed"
        ((issues++))
    fi
    
    if ! flutter devices 2>/dev/null | grep -q "•"; then
        echo -e "${CROSS} No devices available for testing"
        ((issues++))
    fi
    
    # IDE checks
    if ! command_exists code && ! [ -d "/Applications/Android Studio.app" ]; then
        echo -e "${CROSS} No supported IDE found"
        ((issues++))
    fi
    
    # Tool checks
    if ! command_exists git; then
        echo -e "${CROSS} Git is not installed"
        ((issues++))
    fi
    
    if [ "$issues" -eq 0 ]; then
        echo -e "${CHECK} ${GREEN}Your Flutter development environment is ready!${NC}"
        echo -e "${INFO} You can start building amazing Flutter apps!"
    else
        echo -e "${WARNING} Found $issues issue(s) that should be addressed."
        echo -e "${INFO} Please review the recommendations above."
    fi
    echo
}

# Main execution
main() {
    # Record start time
    local start_time=$(date +%s)
    
    # Run all checks
    check_flutter_version
    check_flutter_doctor
    check_devices
    check_ide_setup
    check_dev_tools
    check_flutter_config
    check_global_packages
    test_project_creation
    check_performance
    generate_summary
    
    # Calculate execution time
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo -e "${INFO} Verification completed in ${duration} seconds"
    echo -e "${INFO} Save this output for troubleshooting if needed"
    echo
    echo -e "${BLUE}Happy Flutter development! 🚀${NC}"
}

# Create log file with timestamp
log_file="flutter_env_check_$(date +%Y%m%d_%H%M%S).log"

# Run main function and save output
main 2>&1 | tee "$log_file"

echo -e "${INFO} Full report saved to: $log_file"