# 🛠️ Workshop 6: Navigation & Routing - Getting Started

## 🎯 **Welcome to the Navigation Workshop!**

This workshop will guide you through building a professional **FlutterShop** application with comprehensive navigation patterns, clean architecture, and modern routing techniques.

## 📋 **Pre-Workshop Checklist**

### **✅ Environment Setup**
- [ ] Flutter SDK installed (version 3.10.0 or higher)
- [ ] IDE set up (VS Code or Android Studio)
- [ ] Device/emulator ready for testing
- [ ] Basic understanding of Flutter widgets and state management

### **✅ Knowledge Prerequisites**
- [ ] Completed Lessons 1-5 (Foundation Phase)
- [ ] Understanding of StatefulWidget and StatelessWidget
- [ ] Basic knowledge of Provider state management
- [ ] Familiarity with clean architecture principles from Lesson 5

## 🚀 **Workshop Overview**

### **🎯 What You'll Build**
A complete **e-commerce navigation system** with:
- 📱 **Multi-screen architecture** with bottom navigation and drawer
- 🔐 **Authentication flow** with route guards
- 🛍️ **Product browsing** with deep linking
- 🛒 **Shopping cart** with checkout flow
- 👤 **User profile** with settings management
- 🧭 **Professional navigation** patterns

### **⏱️ Estimated Time**
- **Setup & Architecture**: 45 minutes
- **Core Implementation**: 90 minutes
- **UI & Polish**: 60 minutes
- **Testing & Refinement**: 30 minutes
- **Total**: ~3.5 hours

## 📁 **Project Structure You'll Create**

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── app_routes.dart
│   ├── navigation/
│   │   └── app_router.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── controllers/
│   ├── screens/
│   └── widgets/
└── main.dart
```

## 🛠️ **Step-by-Step Workshop Guide**

### **📝 Step 1: Project Setup (15 minutes)**
1. **Create the project structure** following clean architecture
2. **Add required dependencies** (go_router, provider, equatable)
3. **Set up the basic app shell** with MaterialApp and routing

### **🏗️ Step 2: Architecture Foundation (30 minutes)**
1. **Define navigation entities** (NavigationItem, User, Product)
2. **Create repository interfaces** for navigation and auth
3. **Implement use cases** for navigation logic
4. **Set up dependency injection** pattern

### **🧭 Step 3: Router Configuration (45 minutes)**
1. **Configure GoRouter** with route definitions
2. **Implement route guards** for authentication
3. **Set up shell routes** for persistent navigation
4. **Add deep linking** support

### **🎨 Step 4: UI Implementation (60 minutes)**
1. **Create navigation shell** with bottom nav and drawer
2. **Implement main screens** (Home, Products, Cart, Profile)
3. **Add authentication screens** (Login, Register)
4. **Build product detail** and checkout flows

### **⚡ Step 5: State Management (30 minutes)**
1. **Create navigation controller** with Provider
2. **Implement authentication state** management
3. **Add product and cart** controllers
4. **Connect UI with state** management

### **🧪 Step 6: Testing & Polish (30 minutes)**
1. **Test navigation flows** on different devices
2. **Verify authentication** redirects work correctly
3. **Test deep linking** functionality
4. **Polish UI transitions** and animations

## 📚 **Resources & Documentation**

### **📖 Core Concepts Reference**
- [Concept Guide](../modules/lesson_06/concept.md) - Comprehensive navigation theory
- [Visual Diagrams](../modules/lesson_06/diagram.md) - Architecture and flow diagrams
- [Workshop Guide](../modules/lesson_06/workshop_06.md) - Detailed implementation steps

### **🔗 External Resources**
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Flutter Navigation Guide](https://docs.flutter.dev/cookbook/navigation)
- [Provider State Management](https://pub.dev/packages/provider)

## 🎯 **Learning Objectives**

By completing this workshop, you will:

### **Technical Skills**
- ✅ **Master GoRouter** - Modern declarative routing
- ✅ **Implement Route Guards** - Authentication-based navigation
- ✅ **Build Navigation Architecture** - Clean, testable navigation
- ✅ **Handle Deep Links** - URL-based navigation support
- ✅ **Manage Navigation State** - Centralized state management

### **Architectural Understanding**
- ✅ **Clean Architecture** - Applied to navigation layer
- ✅ **Repository Pattern** - Navigation abstraction
- ✅ **Use Case Pattern** - Business logic separation
- ✅ **Dependency Injection** - Manageable dependencies

### **Professional Development**
- ✅ **Navigation Planning** - Design navigation hierarchies
- ✅ **User Experience** - Intuitive navigation flows
- ✅ **Testing Strategy** - Test navigation components
- ✅ **Performance** - Optimize navigation performance

## 🚨 **Common Challenges & Solutions**

### **🔧 Setup Issues**
**Problem**: GoRouter dependency conflicts
**Solution**: Ensure Flutter SDK is up to date, check `pubspec.yaml` formatting

**Problem**: Clean architecture confusion
**Solution**: Review Lesson 5 clean architecture implementation first

### **🧭 Navigation Issues**
**Problem**: Route guards not working
**Solution**: Check authentication state and router redirect logic

**Problem**: Deep links not working
**Solution**: Verify route patterns and parameter parsing

### **🎨 UI Issues**
**Problem**: Bottom navigation not updating
**Solution**: Check navigation controller state management

**Problem**: Authentication state persistence
**Solution**: Implement proper state storage with SharedPreferences

## 💡 **Pro Tips for Success**

### **🎯 Before You Start**
1. **Read the concept guide** thoroughly
2. **Study the diagrams** to understand architecture
3. **Set up your development environment** properly
4. **Have the Flutter documentation** ready

### **💻 During Development**
1. **Follow clean architecture** principles strictly
2. **Test navigation flows** frequently
3. **Use hot reload** effectively for rapid iteration
4. **Check console logs** for navigation debugging

### **🧪 Testing & Debugging**
1. **Test on multiple screen sizes** early
2. **Verify authentication flows** thoroughly
3. **Test deep linking** with different URLs
4. **Check memory usage** during navigation

## 🎉 **Success Criteria**

Your workshop is complete when you can:

- [ ] **Navigate between all screens** using bottom navigation and drawer
- [ ] **Login and logout** with proper authentication redirects
- [ ] **Access protected routes** only when authenticated
- [ ] **Handle deep links** to specific products and screens
- [ ] **Maintain navigation state** across app restarts
- [ ] **Test the app** on different devices and orientations

## 🔄 **What's Next?**

After completing this workshop:

1. **Experiment** with custom route transitions
2. **Add** navigation analytics
3. **Implement** offline navigation caching
4. **Explore** advanced GoRouter features

## 🆘 **Getting Help**

If you encounter issues during the workshop:

1. **Check the concept guide** for theoretical understanding
2. **Review the diagrams** for architectural clarity
3. **Compare with the answer implementation** in the `answer/lesson_06/` directory
4. **Test smaller pieces** individually to isolate issues

## 🚀 **Ready to Begin?**

Start with the detailed [Workshop Guide](../modules/lesson_06/workshop_06.md) and build an amazing navigation system!

**Remember**: The goal is not just to complete the workshop, but to understand the architectural principles that make navigation maintainable and scalable in professional Flutter applications.

**Let's build something awesome! 🎯**