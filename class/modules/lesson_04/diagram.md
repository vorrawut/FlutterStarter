# 📜 Diagram

## 🏗️ Widget Tree Architecture

### Flutter Widget Tree Structure
```mermaid
graph TD
    A[MyApp] --> B[MaterialApp]
    B --> C[Scaffold]
    C --> D[AppBar]
    C --> E[Body]
    C --> F[FloatingActionButton]
    
    D --> G[Text - 'Widget Gallery']
    E --> H[Column]
    F --> I[Icon - Icons.add]
    
    H --> J[Text Widget Example]
    H --> K[Container Widget Example]
    H --> L[Row Widget Example]
    
    K --> M[Decoration]
    K --> N[Padding]
    K --> O[Child Text]
    
    L --> P[Icon - home]
    L --> Q[Text - 'Home']
    L --> R[Icon - star]
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#e8f5e8
    style D fill:#fff3e0
    style E fill:#fce4ec
    style F fill:#e0f2f1
```

### Three Trees in Flutter
```mermaid
graph LR
    subgraph "Widget Tree"
        A1[Text<br/>'Hello World']
        A2[Container<br/>width: 100]
        A3[Column<br/>children: [...]]
    end
    
    subgraph "Element Tree"
        B1[StatelessElement<br/>Text]
        B2[SingleChildRenderElement<br/>Container]
        B3[MultiChildRenderElement<br/>Column]
    end
    
    subgraph "Render Tree"
        C1[RenderParagraph<br/>Paint text]
        C2[RenderDecoratedBox<br/>Paint container]
        C3[RenderFlex<br/>Layout children]
    end
    
    A1 --> B1
    A2 --> B2
    A3 --> B3
    
    B1 --> C1
    B2 --> C2
    B3 --> C3
    
    style A1 fill:#e3f2fd
    style A2 fill:#e3f2fd
    style A3 fill:#e3f2fd
    style B1 fill:#fff3e0
    style B2 fill:#fff3e0
    style B3 fill:#fff3e0
    style C1 fill:#e8f5e8
    style C2 fill:#e8f5e8
    style C3 fill:#e8f5e8
```

## 🔄 Widget Lifecycle

### StatelessWidget Lifecycle
```mermaid
sequenceDiagram
    participant Framework
    participant Widget
    participant Element
    participant RenderObject
    
    Framework->>Widget: constructor()
    Widget->>Element: createElement()
    Element->>RenderObject: createRenderObject()
    
    loop Every rebuild
        Framework->>Widget: build(context)
        Widget-->>Framework: Widget tree
    end
    
    Framework->>Widget: dispose()
    
    Note over Widget,RenderObject: StatelessWidget is immutable<br/>No internal state changes
```

### StatefulWidget Lifecycle
```mermaid
sequenceDiagram
    participant Framework
    participant Widget
    participant State
    participant Element
    participant RenderObject
    
    Framework->>Widget: constructor()
    Widget->>State: createState()
    State->>Element: createElement()
    Element->>RenderObject: createRenderObject()
    
    State->>State: initState()
    State->>State: didChangeDependencies()
    
    loop Every rebuild
        Framework->>State: build(context)
        State-->>Framework: Widget tree
    end
    
    Note over State: setState() triggers rebuild
    State->>State: setState()
    Framework->>State: build(context)
    
    Widget->>State: didUpdateWidget(oldWidget)
    
    Framework->>State: dispose()
    
    Note over Widget,RenderObject: StatefulWidget can change over time<br/>State persists across rebuilds
```

### State Lifecycle Methods
```mermaid
stateDiagram-v2
    [*] --> initState: Widget created
    initState --> didChangeDependencies: Dependencies ready
    didChangeDependencies --> build: First build
    build --> Active: Widget active
    
    Active --> setState: State change
    setState --> build: Rebuild triggered
    
    Active --> didUpdateWidget: Parent rebuilds
    didUpdateWidget --> build: Update build
    
    Active --> deactivate: Widget removed
    deactivate --> dispose: Cleanup
    dispose --> [*]: Widget destroyed
    
    note right of initState : Initialize state variables<br/>Start animations<br/>Subscribe to streams
    note right of build : Create widget tree<br/>Should be pure function
    note right of dispose : Clean up resources<br/>Cancel subscriptions<br/>Dispose controllers
```

## 🎨 Widget Composition Patterns

### Basic Widget Composition
```mermaid
graph TD
    A[UserProfileCard] --> B[Card]
    B --> C[Padding]
    C --> D[Row]
    
    D --> E[CircleAvatar]
    D --> F[Column]
    D --> G[IconButton]
    
    E --> H[NetworkImage]
    F --> I[Text - Name]
    F --> J[Text - Email]
    F --> K[Text - Status]
    G --> L[Icon - more_vert]
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#e8eaf6
    style D fill:#e0f2f1
    style E fill:#fff8e1
    style F fill:#fce4ec
    style G fill:#f1f8e9
```

### Layout Widget Relationships
```mermaid
graph LR
    subgraph "Flex Widgets"
        A[Row] --> A1[Horizontal Layout]
        B[Column] --> B1[Vertical Layout]
        C[Flex] --> C1[Custom Direction]
    end
    
    subgraph "Flex Children"
        D[Expanded] --> D1[Fill Available Space]
        E[Flexible] --> E1[Flexible Space]
        F[Spacer] --> F1[Empty Space]
    end
    
    subgraph "Positioning"
        G[Stack] --> G1[Overlapping]
        H[Positioned] --> H1[Absolute Position]
        I[Align] --> I1[Relative Position]
    end
    
    A --> D
    B --> E
    G --> H
    
    style A fill:#e3f2fd
    style B fill:#e3f2fd
    style C fill:#e3f2fd
    style D fill:#fff3e0
    style E fill:#fff3e0
    style F fill:#fff3e0
    style G fill:#e8f5e8
    style H fill:#e8f5e8
    style I fill:#e8f5e8
```

## 🔧 Interactive Widget Flow

### Button Interaction Flow
```mermaid
sequenceDiagram
    participant User
    participant Button
    participant State
    participant UI
    
    User->>Button: Tap
    Button->>State: onPressed()
    State->>State: setState(() => _count++)
    State->>UI: build() called
    UI->>User: Updated display
    
    Note over User,UI: User sees immediate feedback<br/>UI reflects new state
```

### Form Input Flow
```mermaid
graph LR
    A[User Input] --> B[TextField]
    B --> C[TextEditingController]
    C --> D[onChanged Callback]
    D --> E[State Update]
    E --> F[setState()]
    F --> G[Widget Rebuild]
    G --> H[UI Update]
    
    style A fill:#e3f2fd
    style B fill:#fff3e0
    style C fill:#f3e5f5
    style D fill:#e8f5e8
    style E fill:#fce4ec
    style F fill:#e0f2f1
    style G fill:#fff8e1
    style H fill:#f1f8e9
```

## 📱 Layout Algorithm Visualization

### Row Layout Algorithm
```mermaid
graph TD
    A[Row Widget] --> B[Measure Children]
    B --> C[Determine Main Axis Size]
    C --> D[Distribute Space]
    D --> E[Position Children]
    
    B --> F[Child 1<br/>Intrinsic Width]
    B --> G[Child 2<br/>Expanded - Flex: 2]
    B --> H[Child 3<br/>Flexible - Flex: 1]
    
    D --> I[Remaining Space<br/>= Total - Intrinsic]
    I --> J[Expanded gets<br/>2/3 of remaining]
    I --> K[Flexible gets<br/>min(intrinsic, 1/3)]
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#e8eaf6
    style D fill:#e0f2f1
    style E fill:#fff8e1
```

### Stack Positioning
```mermaid
graph TD
    A[Stack Widget] --> B[Position Children]
    
    B --> C[Non-positioned Children]
    B --> D[Positioned Children]
    
    C --> E[Fill Stack Size]
    C --> F[Use Alignment]
    
    D --> G[Positioned.top]
    D --> H[Positioned.bottom]
    D --> I[Positioned.left]
    D --> J[Positioned.right]
    
    G --> K[Distance from top edge]
    H --> L[Distance from bottom edge]
    I --> M[Distance from left edge]
    J --> N[Distance from right edge]
    
    style A fill:#e1f5fe
    style C fill:#e8f5e8
    style D fill:#fff3e0
```

## 🎭 Custom Widget Patterns

### Widget Composition Strategy
```mermaid
graph LR
    subgraph "Complex Widget"
        A[FeatureCard]
    end
    
    subgraph "Composed Of"
        B[HeaderSection]
        C[ContentSection]
        D[ActionSection]
    end
    
    subgraph "Basic Widgets"
        E[Text]
        F[Icon]
        G[Container]
        H[Button]
        I[Image]
    end
    
    A --> B
    A --> C
    A --> D
    
    B --> E
    B --> F
    C --> G
    C --> I
    D --> H
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#f3e5f5
    style D fill:#f3e5f5
    style E fill:#e8f5e8
    style F fill:#e8f5e8
    style G fill:#e8f5e8
    style H fill:#e8f5e8
    style I fill:#e8f5e8
```

### Widget Parameter Flow
```mermaid
graph TD
    A[Parent Widget] --> B[CustomCard]
    
    A --> C[title: 'Welcome']
    A --> D[subtitle: 'Hello User']
    A --> E[onTap: () => navigate()]
    A --> F[backgroundColor: Colors.blue]
    
    B --> G[build method]
    
    C --> G
    D --> G
    E --> G
    F --> G
    
    G --> H[Card Widget Tree]
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style G fill:#e8f5e8
    style H fill:#fff3e0
```

## 🚀 Performance Optimization Patterns

### Widget Rebuild Optimization
```mermaid
graph TD
    A[Parent State Change] --> B[setState() called]
    B --> C[Parent rebuild]
    C --> D[Child widgets]
    
    D --> E[const Widget]
    D --> F[StatelessWidget]
    D --> G[StatefulWidget]
    
    E --> H[No Rebuild ✅]
    F --> I[Rebuild if params change]
    G --> J[Always rebuild ❌]
    
    I --> K[Same params?]
    K --> L[No Rebuild ✅]
    K --> M[Rebuild ⚠️]
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#e8eaf6
    style E fill:#e8f5e8
    style F fill:#fff3e0
    style G fill:#ffebee
    style H fill:#e8f5e8
    style L fill:#e8f5e8
```

### Widget Tree Optimization
```mermaid
graph LR
    subgraph "Unoptimized"
        A1[StatefulWidget] --> B1[build method]
        B1 --> C1[Heavy Widget]
        B1 --> D1[Heavy Widget]
        B1 --> E1[Heavy Widget]
    end
    
    subgraph "Optimized"
        A2[StatefulWidget] --> B2[build method]
        B2 --> C2[const Heavy Widget]
        B2 --> D2[const Heavy Widget]
        B2 --> E2[Extracted Widget]
    end
    
    F[State Change] --> A1
    F --> A2
    
    A1 --> G[Rebuilds Everything ❌]
    A2 --> H[Minimal Rebuilds ✅]
    
    style A1 fill:#ffebee
    style A2 fill:#e8f5e8
    style G fill:#ffcdd2
    style H fill:#c8e6c9
```

## 🎯 Widget Selection Guide

### When to Use Which Widget Type
```mermaid
flowchart TD
    A[Need to Display UI?] --> B[Does it change over time?]
    
    B --> C[No - StatelessWidget]
    B --> D[Yes - StatefulWidget]
    
    C --> E[Pure function of inputs]
    C --> F[Immutable properties]
    C --> G[No internal state]
    
    D --> H[Internal state management]
    D --> I[User interactions]
    D --> J[Animations]
    D --> K[Timers/Streams]
    
    style C fill:#e8f5e8
    style D fill:#fff3e0
    style E fill:#c8e6c9
    style F fill:#c8e6c9
    style G fill:#c8e6c9
    style H fill:#ffe0b2
    style I fill:#ffe0b2
    style J fill:#ffe0b2
    style K fill:#ffe0b2
```

### Layout Widget Decision Tree
```mermaid
flowchart TD
    A[Need Layout?] --> B[Linear or Overlapping?]
    
    B --> C[Linear]
    B --> D[Overlapping]
    
    C --> E[Direction?]
    E --> F[Horizontal - Row]
    E --> G[Vertical - Column]
    
    D --> H[Stack]
    
    F --> I[Space distribution?]
    G --> I
    I --> J[Equal - MainAxisAlignment]
    I --> K[Weighted - Expanded/Flexible]
    I --> L[Fixed - SizedBox]
    
    H --> M[Positioning?]
    M --> N[Absolute - Positioned]
    M --> O[Relative - Align]
    
    style F fill:#e8f5e8
    style G fill:#e8f5e8
    style H fill:#fff3e0
    style J fill:#c8e6c9
    style K fill:#c8e6c9
    style L fill:#c8e6c9
    style N fill:#ffe0b2
    style O fill:#ffe0b2
```

## 🧪 Widget Testing Architecture

### Widget Test Structure
```mermaid
graph TD
    A[Widget Test] --> B[WidgetTester]
    B --> C[pumpWidget]
    C --> D[Build Widget Tree]
    
    D --> E[find]
    E --> F[byType]
    E --> G[byKey]
    E --> H[text]
    E --> I[byIcon]
    
    F --> J[expect]
    G --> J
    H --> J
    I --> J
    
    J --> K[findsOneWidget]
    J --> L[findsNothing]
    J --> M[findsNWidgets]
    
    B --> N[tap/pump]
    N --> O[Simulate Interaction]
    O --> P[Verify Changes]
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style D fill:#e8f5e8
    style J fill:#fff3e0
    style O fill:#fce4ec
```

---

**💡 Visual Learning Note**: These diagrams illustrate the fundamental concepts of Flutter widgets. Use them as reference when building your own widgets and understanding how Flutter's widget system works under the hood. The visual representations help cement the theoretical knowledge gained in the concept documentation.