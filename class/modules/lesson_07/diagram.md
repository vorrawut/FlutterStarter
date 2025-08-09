# 📜 Diagram

## 🎨 **Material 3 Theming Architecture**

This lesson demonstrates a comprehensive theming system built with clean architecture principles and Material 3 design standards.

---

## **Theme Architecture Overview**

```mermaid
flowchart TD
    A[User Interface] --> B[Theme Controller]
    B --> C[Theme Use Cases]
    C --> D[Theme Repository]
    D --> E[Theme Data Source]
    E --> F[SharedPreferences]
    
    B --> G[Material 3 Theme Builder]
    G --> H[Dynamic Color Generation]
    G --> I[Typography System]
    G --> J[Component Themes]
    
    H --> K[Light Theme]
    H --> L[Dark Theme]
    H --> M[High Contrast Themes]
    
    subgraph "Theme Extensions"
        N[Spacing Extension]
        O[Radius Extension]
        P[Ecommerce Extension]
    end
    
    G --> N
    G --> O
    G --> P
    
    style A fill:#e1f5fe
    style B fill:#fff3e0
    style G fill:#f3e5f5
    style K fill:#fff9c4
    style L fill:#303030,color:#fff
    style M fill:#ffcdd2
```

---

## **Theme Settings Data Flow**

```mermaid
sequenceDiagram
    participant U as User
    participant TC as ThemeController
    participant UC as UpdateThemeUseCase
    participant R as ThemeRepository
    participant DS as LocalDataSource
    participant SP as SharedPreferences
    
    U->>TC: Change Theme Mode
    TC->>UC: updateThemeMode(dark)
    UC->>R: getThemeSettings()
    R->>DS: getThemeSettings()
    DS->>SP: getString("theme_settings")
    SP-->>DS: JSON String
    DS-->>R: ThemeSettingsModel
    R-->>UC: ThemeSettings
    
    UC->>UC: Validate & Update Settings
    UC->>R: updateThemeSettings(newSettings)
    R->>DS: saveThemeSettings(model)
    DS->>SP: setString("theme_settings", json)
    SP-->>DS: Success
    DS-->>R: Success
    R-->>UC: Success
    
    UC-->>TC: ThemeUpdateResult.success
    TC->>TC: notifyListeners()
    TC-->>U: UI Updates with New Theme
```

---

## **Material 3 Color System Architecture**

```mermaid
graph TB
    subgraph "Seed Color Input"
        SC[Seed Color: #6750A4]
    end
    
    subgraph "HCT Color Space"
        H[Hue: 270°]
        C[Chroma: 36]
        T[Tone: 0-100]
    end
    
    SC --> H
    SC --> C
    SC --> T
    
    subgraph "Light Color Scheme"
        LP[Primary: Tone 40]
        LOL[OnPrimary: Tone 100]
        LPC[PrimaryContainer: Tone 90]
        LOPC[OnPrimaryContainer: Tone 10]
        LS[Secondary: Tone 40]
        LOS[OnSecondary: Tone 100]
        LSC[SecondaryContainer: Tone 90]
        LOSC[OnSecondaryContainer: Tone 10]
    end
    
    subgraph "Dark Color Scheme"
        DP[Primary: Tone 80]
        DOL[OnPrimary: Tone 20]
        DPC[PrimaryContainer: Tone 30]
        DOPC[OnPrimaryContainer: Tone 90]
        DS[Secondary: Tone 80]
        DOS[OnSecondary: Tone 20]
        DSC[SecondaryContainer: Tone 30]
        DOSC[OnSecondaryContainer: Tone 90]
    end
    
    H --> LP
    C --> LP
    T --> LP
    
    H --> DP
    C --> DP
    T --> DP
    
    style SC fill:#6750A4,color:#fff
    style LP fill:#6750A4,color:#fff
    style DP fill:#D0BCFF,color:#000
    style LPC fill:#EADDFF,color:#000
    style DPC fill:#4F378B,color:#fff
```

---

## **Theme Component Hierarchy**

```mermaid
graph TD
    subgraph "App Theme"
        AT[AppTheme.light() / AppTheme.dark()]
    end
    
    subgraph "Core Systems"
        CS[ColorScheme]
        TS[TextTheme]
        CE[Custom Extensions]
    end
    
    subgraph "Component Themes"
        AB[AppBarTheme]
        BN[BottomNavigationBarTheme]
        EB[ElevatedButtonTheme]
        OB[OutlinedButtonTheme]
        TB[TextButtonTheme]
        IT[InputDecorationTheme]
        CT[CardTheme]
        DT[DialogTheme]
        ST[SnackBarTheme]
    end
    
    subgraph "Custom Extensions"
        SP[SpacingThemeExtension]
        RT[RadiusThemeExtension]
        ET[EcommerceThemeExtension]
    end
    
    AT --> CS
    AT --> TS
    AT --> CE
    
    CS --> AB
    CS --> BN
    CS --> EB
    CS --> OB
    CS --> TB
    CS --> IT
    CS --> CT
    CS --> DT
    CS --> ST
    
    CE --> SP
    CE --> RT
    CE --> ET
    
    style AT fill:#e8f5e8
    style CS fill:#fff3e0
    style TS fill:#f3e5f5
    style CE fill:#e1f5fe
```

---

## **Theme State Management Pattern**

```mermaid
stateDiagram-v2
    [*] --> Loading: App Start
    Loading --> LoadingSettings: Initialize Theme
    LoadingSettings --> Ready: Settings Loaded
    LoadingSettings --> Error: Load Failed
    
    Ready --> UpdatingMode: Change Theme Mode
    Ready --> UpdatingColor: Change Seed Color
    Ready --> UpdatingAccessibility: Toggle High Contrast
    Ready --> UpdatingScale: Change Text Scale
    
    UpdatingMode --> Saving: Update Repository
    UpdatingColor --> Saving: Update Repository
    UpdatingAccessibility --> Saving: Update Repository
    UpdatingScale --> Saving: Update Repository
    
    Saving --> Ready: Save Success
    Saving --> Error: Save Failed
    
    Error --> Ready: Retry Success
    Error --> [*]: Reset to Defaults
    
    Ready --> Resetting: Reset to Defaults
    Resetting --> Loading: Clear Settings
```

---

## **Accessibility Theme Considerations**

```mermaid
mindmap
  root((Accessibility<br/>Features))
    High Contrast
      WCAG AA Compliance
      Enhanced Color Ratios
      Clear Focus Indicators
      Strong Border Definition
    Text Scaling
      50% - 200% Range
      Proportional Spacing
      Readable Font Sizes
      Layout Adaptation
    Color Independence
      No Color-Only Information
      Icon + Text Labels
      Pattern Alternatives
      Status Indicators
    Dark Mode Support
      Reduced Eye Strain
      Battery Optimization
      User Preference
      System Integration
    System Integration
      Platform Themes
      Wallpaper Colors
      Accessibility Settings
      User Preferences
```

---

## **Performance Optimization Strategy**

```mermaid
graph LR
    subgraph "Theme Loading"
        TL[Theme Settings Loaded] --> TC[Theme Created]
        TC --> TCA[Theme Cached]
        TCA --> TA[Theme Applied]
    end
    
    subgraph "Theme Updates"
        TU[Theme Update Request] --> TV[Validate Changes]
        TV --> TS[Theme Settings Saved]
        TS --> TR[Theme Rebuilt]
        TR --> TN[Notify Listeners]
    end
    
    subgraph "Performance Features"
        LC[Lazy Color Generation]
        MC[Material Theme Caching]
        EC[Extension Caching]
        MR[Minimal Rebuilds]
    end
    
    TL --> LC
    TC --> MC
    TA --> EC
    TN --> MR
    
    style LC fill:#c8e6c9
    style MC fill:#c8e6c9
    style EC fill:#c8e6c9
    style MR fill:#c8e6c9
```

---

## **Theme Testing Architecture**

```mermaid
graph TB
    subgraph "Testing Layers"
        UT[Unit Tests]
        WT[Widget Tests]
        IT[Integration Tests]
        GT[Golden Tests]
    end
    
    subgraph "Unit Test Coverage"
        TC[Theme Controller Logic]
        UC[Use Case Validation]
        CS[Color Scheme Generation]
        TS[Theme Settings Persistence]
    end
    
    subgraph "Widget Test Coverage"
        TW[Theme Widgets Render]
        CP[Color Picker Interaction]
        MS[Mode Selector Behavior]
        AC[Accessibility Controls]
    end
    
    subgraph "Integration Test Coverage"
        TF[Theme Flow End-to-End]
        PS[Persistence Across Restarts]
        SM[System Mode Integration]
        AT[Accessibility Features]
    end
    
    subgraph "Golden Test Coverage"
        LT[Light Theme Rendering]
        DT[Dark Theme Rendering]
        HC[High Contrast Rendering]
        SC[Scale Factor Rendering]
    end
    
    UT --> TC
    UT --> UC
    UT --> CS
    UT --> TS
    
    WT --> TW
    WT --> CP
    WT --> MS
    WT --> AC
    
    IT --> TF
    IT --> PS
    IT --> SM
    IT --> AT
    
    GT --> LT
    GT --> DT
    GT --> HC
    GT --> SC
    
    style UT fill:#e8f5e8
    style WT fill:#fff3e0
    style IT fill:#f3e5f5
    style GT fill:#e1f5fe
```

---

## **Key Architecture Benefits**

### **🏗️ Clean Architecture**
- **Separation of Concerns**: Theme logic isolated from UI
- **Dependency Inversion**: Repository pattern enables testing
- **Single Responsibility**: Each class has one clear purpose
- **Testability**: Easy to mock dependencies and test logic

### **🎨 Material 3 Integration**
- **Dynamic Colors**: Generate harmonious color schemes
- **Accessibility**: WCAG compliant contrast ratios
- **Platform Integration**: System wallpaper color adaptation
- **Modern Design**: Latest Material Design specifications

### **⚡ Performance Optimization**
- **Efficient Caching**: Minimize theme generation overhead
- **Lazy Loading**: Generate themes only when needed
- **Minimal Rebuilds**: Update only affected widgets
- **Memory Management**: Proper disposal of resources

### **♿ Accessibility Excellence**
- **High Contrast**: Enhanced visibility for low vision users
- **Text Scaling**: Flexible font size adaptation
- **Color Independence**: Information not dependent on color alone
- **Screen Reader Support**: Semantic markup and navigation

**This theming architecture provides a solid foundation for creating beautiful, accessible, and maintainable Flutter applications! 🎨✨**