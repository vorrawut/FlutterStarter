# 📜 Diagram

## 🎯 **Navigation Architecture Overview**

```mermaid
graph TB
    subgraph "Presentation Layer"
        A[NavigationController] --> B[MainNavigationShell]
        B --> C[HomeScreen]
        B --> D[ProductScreen]
        B --> E[ProfileScreen]
        F[LoginScreen] --> B
    end
    
    subgraph "Domain Layer"
        G[NavigateToRouteUseCase] --> H[NavigationRepository Interface]
        I[AuthenticateUserUseCase] --> J[AuthRepository Interface]
        K[NavigationItem Entity]
        L[User Entity]
    end
    
    subgraph "Data Layer"
        M[NavigationRepositoryImpl] --> H
        N[AuthRepositoryImpl] --> J
        O[GoRouter Instance]
        P[SharedPreferences]
    end
    
    A --> G
    A --> I
    M --> O
    N --> P
    
    classDef presentation fill:#e1f5fe
    classDef domain fill:#f3e5f5
    classDef data fill:#e8f5e8
    
    class A,B,C,D,E,F presentation
    class G,H,I,J,K,L domain
    class M,N,O,P data
```

## 🧭 **Navigation Flow Diagram**

```mermaid
flowchart TD
    Start([App Launch]) --> Splash[SplashScreen]
    Splash --> AuthCheck{Authenticated?}
    
    AuthCheck -->|Yes| MainShell[MainNavigationShell]
    AuthCheck -->|No| Login[LoginScreen]
    
    Login --> LoginSuccess{Login Success?}
    LoginSuccess -->|Yes| MainShell
    LoginSuccess -->|No| Login
    
    MainShell --> Home[🏠 HomeScreen]
    MainShell --> Products[🛍️ ProductsScreen]
    MainShell --> Cart[🛒 CartScreen]
    MainShell --> Profile[👤 ProfileScreen]
    
    Products --> ProductDetail[📱 ProductDetailScreen]
    ProductDetail --> AddToCart{Add to Cart?}
    AddToCart -->|Yes| Cart
    AddToCart -->|No| Products
    
    Cart --> Checkout[💳 CheckoutScreen]
    Checkout --> OrderConfirm[✅ OrderConfirmationScreen]
    
    Profile --> Settings[⚙️ SettingsScreen]
    Profile --> Orders[📦 OrderHistoryScreen]
    Profile --> Logout{Logout?}
    Logout -->|Yes| Login
    
    classDef startEnd fill:#4caf50,color:#fff
    classDef decision fill:#ff9800,color:#fff
    classDef screen fill:#2196f3,color:#fff
    classDef shell fill:#9c27b0,color:#fff
    
    class Start,OrderConfirm startEnd
    class AuthCheck,LoginSuccess,AddToCart,Logout decision
    class Home,Products,Cart,Profile,ProductDetail,Checkout,Settings,Orders,Login screen
    class MainShell shell
```

## 🏗️ **Route Structure Hierarchy**

```mermaid
graph TD
    Root["/"] --> Splash["/splash"]
    Root --> Auth["/auth"]
    Root --> Main["/main"]
    
    Auth --> Login["/auth/login"]
    Auth --> Register["/auth/register"]
    Auth --> ForgotPassword["/auth/forgot-password"]
    
    Main --> Home["/home"]
    Main --> Products["/products"]
    Main --> Cart["/cart"]
    Main --> Profile["/profile"]
    
    Products --> ProductList["/products (list)"]
    Products --> ProductDetail["/products/:id"]
    Products --> ProductSearch["/products/search"]
    
    Profile --> ProfileMain["/profile (main)"]
    Profile --> ProfileSettings["/profile/settings"]
    Profile --> ProfileOrders["/profile/orders"]
    Profile --> ProfileFavorites["/profile/favorites"]
    
    Cart --> CartMain["/cart (main)"]
    Cart --> Checkout["/checkout"]
    Cart --> OrderConfirm["/order-confirmation"]
    
    classDef root fill:#4caf50,color:#fff
    classDef category fill:#2196f3,color:#fff
    classDef page fill:#ff9800,color:#fff
    
    class Root root
    class Auth,Main,Products,Profile,Cart category
    class Splash,Login,Register,ForgotPassword,Home,ProductList,ProductDetail,ProductSearch,ProfileMain,ProfileSettings,ProfileOrders,ProfileFavorites,CartMain,Checkout,OrderConfirm page
```

## 🔒 **Authentication & Route Guards Flow**

```mermaid
sequenceDiagram
    participant User
    participant App
    participant RouteGuard
    participant AuthService
    participant Navigation
    
    User->>App: Navigate to /profile
    App->>RouteGuard: Check route access
    RouteGuard->>AuthService: Get current user
    
    alt User is authenticated
        AuthService-->>RouteGuard: Return user
        RouteGuard-->>App: Allow access
        App->>Navigation: Navigate to profile
        Navigation-->>User: Show ProfileScreen
    else User not authenticated
        AuthService-->>RouteGuard: Return null
        RouteGuard-->>App: Deny access
        App->>Navigation: Redirect to login
        Navigation-->>User: Show LoginScreen
        
        User->>App: Complete login
        App->>AuthService: Authenticate user
        AuthService-->>App: Return authenticated user
        App->>Navigation: Navigate to intended route
        Navigation-->>User: Show ProfileScreen
    end
```

## 📱 **Navigation UI Components Structure**

```mermaid
graph TB
    subgraph "MainNavigationShell"
        AppBar[AppBar] --> AppBarActions[Actions: Cart, Search]
        Drawer[NavigationDrawer] --> DrawerItems[User Profile, Menu Items, Logout]
        Body[Body Content] --> CurrentScreen[Current Screen Widget]
        BottomNav[BottomNavigationBar] --> NavTabs[Home, Products, Cart, Profile]
    end
    
    subgraph "Navigation State Management"
        NavController[NavigationController] --> CurrentIndex[Current Tab Index]
        NavController --> RouteHistory[Navigation History]
        NavController --> NavItems[Navigation Items List]
    end
    
    subgraph "Route Configuration"
        GoRouter[GoRouter Instance] --> Routes[Route Definitions]
        Routes --> Guards[Route Guards]
        Routes --> Redirects[Authentication Redirects]
    end
    
    NavController --> GoRouter
    MainNavigationShell --> NavController
    
    classDef ui fill:#e3f2fd
    classDef state fill:#f3e5f5
    classDef config fill:#e8f5e8
    
    class AppBar,Drawer,Body,BottomNav,AppBarActions,DrawerItems,CurrentScreen,NavTabs ui
    class NavController,CurrentIndex,RouteHistory,NavItems state
    class GoRouter,Routes,Guards,Redirects config
```

## 🎨 **Navigation Patterns Comparison**

```mermaid
graph LR
    subgraph "Navigator 1.0 (Imperative)"
        A1[Screen A] -->|push| B1[Screen B]
        B1 -->|push| C1[Screen C]
        C1 -->|pop| B1
        B1 -->|pop| A1
    end
    
    subgraph "Navigator 2.0 (Declarative)"
        A2[Route Config] --> B2[Route Parser]
        B2 --> C2[Router Delegate]
        C2 --> D2[Navigator Widget]
        D2 --> E2[Page Stack]
    end
    
    subgraph "Navigation Patterns"
        F[Bottom Navigation] --> F1[Tab-based]
        F --> F2[Persistent Shell]
        
        G[Stack Navigation] --> G1[Push/Pop]
        G --> G2[Replace/Clear]
        
        H[Modal Navigation] --> H1[Dialog/Sheet]
        H --> H2[Full Screen Modal]
    end
    
    classDef old fill:#ffcdd2
    classDef new fill:#c8e6c9
    classDef pattern fill:#fff3e0
    
    class A1,B1,C1 old
    class A2,B2,C2,D2,E2 new
    class F,G,H,F1,F2,G1,G2,H1,H2 pattern
```

## 🔄 **Navigation State Lifecycle**

```mermaid
stateDiagram-v2
    [*] --> AppStartup
    AppStartup --> SplashScreen
    
    SplashScreen --> CheckingAuth : Initialize
    CheckingAuth --> Authenticated : User logged in
    CheckingAuth --> Unauthenticated : No user
    
    Unauthenticated --> LoginFlow
    LoginFlow --> AuthenticationInProgress
    AuthenticationInProgress --> Authenticated : Success
    AuthenticationInProgress --> LoginFlow : Failed
    
    Authenticated --> MainNavigation
    MainNavigation --> HomeTab
    MainNavigation --> ProductsTab
    MainNavigation --> CartTab
    MainNavigation --> ProfileTab
    
    HomeTab --> ProductDetail : Navigate to product
    ProductsTab --> ProductDetail : Select product
    ProductDetail --> CartTab : Add to cart
    
    ProfileTab --> Settings : Open settings
    ProfileTab --> Orders : View orders
    ProfileTab --> LoggingOut : Logout
    
    LoggingOut --> Unauthenticated : Success
    
    CartTab --> CheckoutFlow : Proceed to checkout
    CheckoutFlow --> OrderComplete : Payment success
    OrderComplete --> HomeTab : Continue shopping
```

## 📊 **Performance & Memory Management**

```mermaid
graph TD
    subgraph "Route Memory Management"
        A[Route Stack] --> B[Active Routes]
        A --> C[Cached Routes]
        A --> D[Disposed Routes]
        
        B --> B1[Current Screen]
        B --> B2[Navigation Shell]
        
        C --> C1[Recently Visited]
        C --> C2[Frequently Accessed]
        
        D --> D1[Memory Released]
        D --> D2[Widgets Disposed]
    end
    
    subgraph "Navigation Performance"
        E[Route Transitions] --> E1[Animation Performance]
        E --> E2[Memory Usage]
        
        F[Route Preloading] --> F1[Critical Routes]
        F --> F2[User-Specific Routes]
        
        G[Navigation Analytics] --> G1[Route Timing]
        G --> G2[User Flow Tracking]
    end
    
    subgraph "Optimization Strategies"
        H[Lazy Loading] --> H1[On-Demand Screens]
        I[Route Caching] --> I1[Smart Caching]
        J[Memory Monitoring] --> J1[Automatic Cleanup]
    end
    
    A --> E
    E --> H
    F --> I
    G --> J
    
    classDef memory fill:#ffebee
    classDef performance fill:#e8f5e8
    classDef optimization fill:#fff3e0
    
    class A,B,C,D,B1,B2,C1,C2,D1,D2 memory
    class E,F,G,E1,E2,F1,F2,G1,G2 performance
    class H,I,J,H1,I1,J1 optimization
```

## 🧪 **Testing Strategy Diagram**

```mermaid
graph TB
    subgraph "Unit Tests"
        A[Navigation Use Cases] --> A1[Route Validation]
        A --> A2[Authentication Logic]
        A --> A3[Parameter Parsing]
        
        B[Navigation Entities] --> B1[Route Objects]
        B --> B2[User Models]
        B --> B3[Navigation Items]
    end
    
    subgraph "Widget Tests"
        C[Navigation Components] --> C1[Bottom Navigation]
        C --> C2[Navigation Drawer]
        C --> C3[AppBar Actions]
        
        D[Screen Tests] --> D1[Screen Rendering]
        D --> D2[Navigation Triggers]
        D --> D3[State Updates]
    end
    
    subgraph "Integration Tests"
        E[Navigation Flows] --> E1[Authentication Flow]
        E --> E2[Shopping Flow]
        E --> E3[Profile Management]
        
        F[Route Tests] --> F1[Deep Link Handling]
        F --> F2[Route Guards]
        F --> F3[Route Parameters]
    end
    
    subgraph "Test Doubles"
        G[Mock Services] --> G1[Mock Navigation Repository]
        G --> G2[Mock Auth Service]
        G --> G3[Mock Route Parser]
    end
    
    A --> G
    C --> G
    E --> G
    
    classDef unit fill:#e3f2fd
    classDef widget fill:#f3e5f5
    classDef integration fill:#e8f5e8
    classDef mocks fill:#fff3e0
    
    class A,B,A1,A2,A3,B1,B2,B3 unit
    class C,D,C1,C2,C3,D1,D2,D3 widget
    class E,F,E1,E2,E3,F1,F2,F3 integration
    class G,G1,G2,G3 mocks
```

## 🔧 **Implementation Architecture**

```mermaid
classDiagram
    class NavigationController {
        -int currentIndex
        -bool isLoading
        -String? errorMessage
        +navigateToRoute()
        +updateCurrentIndex()
        +getBottomNavItems()
    }
    
    class NavigateToRouteUseCase {
        -NavigationRepository repository
        -AuthRepository authRepository
        +execute(route, extra)
        -requiresAuth(route)
    }
    
    class NavigationRepository {
        <<interface>>
        +navigateToRoute()
        +navigateBack()
        +getCurrentRoute()
        +getNavigationItems()
    }
    
    class NavigationRepositoryImpl {
        -GoRouter goRouter
        +navigateToRoute()
        +navigateBack()
        +getCurrentRoute()
        +getNavigationItems()
    }
    
    class AppRouter {
        +createRouter()
        -handleAuthRedirect()
        -isProtectedRoute()
    }
    
    class NavigationItem {
        +String route
        +String title
        +IconData icon
        +bool requiresAuth
        +List~NavigationItem~? children
    }
    
    NavigationController --> NavigateToRouteUseCase
    NavigateToRouteUseCase --> NavigationRepository
    NavigationRepositoryImpl ..|> NavigationRepository
    NavigationRepositoryImpl --> AppRouter
    NavigationController --> NavigationItem
```

---

## 🎓 **Key Visual Learning Points**

### **🧭 Navigation Architecture**
- **Clean Separation**: Clear boundaries between presentation, domain, and data layers
- **Dependency Direction**: Dependencies point inward following clean architecture principles
- **Repository Pattern**: Navigation operations abstracted through interfaces

### **🔄 Navigation Flow**
- **Authentication Integration**: Route guards protect authenticated routes
- **State Management**: Centralized navigation state with proper lifecycle management
- **Error Handling**: Graceful handling of navigation failures and redirects

### **📱 UI Structure**
- **Shell Pattern**: Persistent navigation shell with tab-based navigation
- **Hierarchical Routes**: Proper parent-child route relationships
- **Component Separation**: Clear separation between navigation UI components

### **🎯 Performance Optimization**
- **Memory Management**: Proper disposal of navigation resources
- **Route Caching**: Smart caching of frequently accessed routes
- **Lazy Loading**: On-demand loading of navigation screens

These diagrams provide visual guidance for understanding the complex navigation patterns and architecture principles covered in this lesson. Use them as reference while implementing the navigation system in your Flutter application.

**Continue to:** [Workshop 6](workshop_06.md) to implement these concepts in practice!