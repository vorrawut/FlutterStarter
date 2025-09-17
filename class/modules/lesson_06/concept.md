# 🧭 Concepts

## 📚 **Key Concepts**

### **🧭 Navigation Fundamentals**

#### **Navigator 1.0 vs Navigator 2.0**
- **Navigator 1.0 (Imperative)** - Simple push/pop operations
- **Navigator 2.0 (Declarative)** - Complete control over navigation stack

#### **Navigation Stack Management**
```dart
// Navigator 1.0 - Imperative approach
Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => DetailScreen()),
);

// Navigator 2.0 - Declarative approach
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/detail':
        return MaterialPageRoute(builder: (_) => DetailScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
```

### **🛣️ Routing Architecture**

#### **Route Definition Patterns**
- **Named Routes** - String-based route identification
- **Generated Routes** - Dynamic route creation
- **Route Guards** - Authentication and authorization
- **Route Parameters** - Data passing between screens

### **📱 Multi-Screen Application Design**

#### **Screen Hierarchy Planning**
```
📱 App Navigation Structure
├── 🏠 Home Screen (/)
│   ├── 📊 Dashboard Tab
│   ├── 🛍️ Products Tab
│   └── 👤 Profile Tab
├── 📋 Product Detail (/product/:id)
│   ├── 📸 Image Gallery
│   ├── 📝 Product Info
│   └── 🛒 Add to Cart
├── 👤 Profile (/profile)
│   ├── ⚙️ Settings (/profile/settings)
│   ├── 📦 Orders (/profile/orders)
│   └── ❤️ Favorites (/profile/favorites)
└── 🔐 Authentication
    ├── 📝 Login (/login)
    └── 📝 Register (/register)
```