# 📊 Diagrams 05: Advanced Layout Architecture

## 🏗️ Flutter Layout System Architecture

### Constraint-Based Layout Flow
```mermaid
graph TD
    A[Parent Widget] --> B[BoxConstraints]
    B --> C[Child Widget]
    C --> D[Size Calculation]
    D --> E[Size Report]
    E --> F[Parent Positioning]
    F --> G[Final Layout]
    
    B --> B1["minWidth: 0<br/>maxWidth: 300<br/>minHeight: 0<br/>maxHeight: 200"]
    D --> D1["width: 250<br/>height: 150<br/>(within constraints)"]
    F --> F1["x: 25<br/>y: 25<br/>(parent decides)"]
    
    style A fill:#e1f5fe
    style C fill:#f3e5f5
    style G fill:#e8f5e8
    style B1 fill:#fff3e0
    style D1 fill:#fce4ec
    style F1 fill:#e0f2f1
```

### Three-Pass Layout Algorithm
```mermaid
sequenceDiagram
    participant P as Parent Widget
    participant C as Child Widget
    participant R as RenderObject
    
    Note over P,R: Pass 1: Constraints Down
    P->>C: Send BoxConstraints
    C->>R: Apply constraints
    
    Note over P,R: Pass 2: Sizes Up
    R->>C: Calculate size within constraints
    C->>P: Report actual size
    
    Note over P,R: Pass 3: Position Assignment
    P->>C: Assign position (x, y)
    C->>R: Final positioning
    
    Note over P,R: Result: Laid out widget tree
```

## 📐 Flex Layout System

### Row/Column Layout Algorithm
```mermaid
flowchart TD
    A[Flex Container] --> B[Calculate Main Axis Space]
    B --> C[Distribute to Non-Flex Children]
    C --> D[Calculate Remaining Space]
    D --> E[Distribute to Flex Children]
    E --> F[Apply MainAxisAlignment]
    F --> G[Apply CrossAxisAlignment]
    G --> H[Position All Children]
    
    subgraph "Flex Distribution"
        I[Child 1: flex=1] --> J[Gets 1/4 of remaining space]
        K[Child 2: flex=2] --> L[Gets 2/4 of remaining space]
        M[Child 3: flex=1] --> N[Gets 1/4 of remaining space]
    end
    
    E --> I
    E --> K
    E --> M
    
    style A fill:#e3f2fd
    style H fill:#e8f5e8
    style I fill:#fff3e0
    style K fill:#fce4ec
    style M fill:#e0f2f1
```

### MainAxisAlignment Visualization
```mermaid
graph LR
    subgraph "MainAxisAlignment.start"
        A1[Child1] --> A2[Child2] --> A3[Child3] --> A4[     Empty Space     ]
    end
    
    subgraph "MainAxisAlignment.center"
        B1[  Empty  ] --> B2[Child1] --> B3[Child2] --> B4[Child3] --> B5[  Empty  ]
    end
    
    subgraph "MainAxisAlignment.spaceBetween"
        C1[Child1] --> C2[  Space  ] --> C3[Child2] --> C4[  Space  ] --> C5[Child3]
    end
    
    subgraph "MainAxisAlignment.spaceEvenly"
        D1[Space] --> D2[Child1] --> D3[Space] --> D4[Child2] --> D5[Space] --> D6[Child3] --> D7[Space]
    end
    
    style A1 fill:#e3f2fd
    style A2 fill:#e3f2fd
    style A3 fill:#e3f2fd
    style B2 fill:#e3f2fd
    style B3 fill:#e3f2fd
    style B4 fill:#e3f2fd
    style C1 fill:#e3f2fd
    style C3 fill:#e3f2fd
    style C5 fill:#e3f2fd
    style D2 fill:#e3f2fd
    style D4 fill:#e3f2fd
    style D6 fill:#e3f2fd
```

## 📱 Responsive Design Breakpoints

### Screen Size Categories
```mermaid
graph LR
    A[0px] --> B[576px<br/>Small/Mobile]
    B --> C[768px<br/>Medium/Tablet]
    C --> D[992px<br/>Large/Desktop]
    D --> E[1200px<br/>Extra Large]
    E --> F[1400px<br/>Extra Extra Large]
    
    subgraph "Device Categories"
        G[📱 Mobile<br/>Portrait & Landscape]
        H[📱 Tablet<br/>Portrait & Landscape]
        I[💻 Desktop<br/>Standard Resolution]
        J[🖥️ Large Desktop<br/>High Resolution]
    end
    
    B -.-> G
    C -.-> H
    D -.-> I
    E -.-> J
    
    style B fill:#e8f5e8
    style C fill:#fff3e0
    style D fill:#e3f2fd
    style E fill:#fce4ec
    style F fill:#f3e5f5
```

### Responsive Layout Adaptation
```mermaid
graph TD
    A[Layout Component] --> B{Screen Width}
    
    B -->|< 600px| C[Mobile Layout]
    B -->|600-1024px| D[Tablet Layout]
    B -->|> 1024px| E[Desktop Layout]
    
    C --> C1[Single Column<br/>Stack Navigation<br/>Compact Spacing]
    
    D --> D1[Two Column<br/>Tab Navigation<br/>Medium Spacing]
    
    E --> E1[Multi Column<br/>Sidebar Navigation<br/>Generous Spacing]
    
    subgraph "Layout Patterns"
        F[Grid: 1 column] --> C1
        G[Grid: 2 columns] --> D1
        H[Grid: 3+ columns] --> E1
    end
    
    style C fill:#ffebee
    style D fill:#e3f2fd
    style E fill:#e8f5e8
    style C1 fill:#ffcdd2
    style D1 fill:#bbdefb
    style E1 fill:#c8e6c9
```

## 🎯 Stack & Positioning System

### Stack Layout Architecture
```mermaid
graph TD
    A[Stack Container] --> B[Background Layer]
    A --> C[Positioned Children]
    A --> D[Non-Positioned Children]
    
    B --> B1[Full Container Size<br/>Base Layer]
    
    C --> C1[Positioned.top]
    C --> C2[Positioned.bottom]
    C --> C3[Positioned.left]
    C --> C4[Positioned.right]
    C --> C5[Positioned.fill]
    
    D --> D1[Align.center]
    D --> D2[Align.topRight]
    D --> D3[Natural Position]
    
    subgraph "Positioning Types"
        E[Absolute Positioning<br/>Positioned widget]
        F[Relative Positioning<br/>Align widget]
        G[Natural Flow<br/>Stack order]
    end
    
    C --> E
    D --> F
    B --> G
    
    style A fill:#e1f5fe
    style E fill:#ffebee
    style F fill:#e8f5e8
    style G fill:#fff3e0
```

### Z-Index Layering
```mermaid
graph LR
    subgraph "Stack Children (Bottom to Top)"
        A[Layer 0<br/>Background<br/>z-index: 0]
        A --> B[Layer 1<br/>Content<br/>z-index: 1]
        B --> C[Layer 2<br/>Overlay<br/>z-index: 2]
        C --> D[Layer 3<br/>Modal<br/>z-index: 3]
        D --> E[Layer 4<br/>Tooltip<br/>z-index: 4]
    end
    
    style A fill:#e0f2f1
    style B fill:#e8f5e8
    style C fill:#fff3e0
    style D fill:#fce4ec
    style E fill:#f3e5f5
```

## 🔄 Widget Composition Patterns

### Complex Widget Hierarchy
```mermaid
graph TD
    A[ProfileCard] --> B[Container]
    B --> C[Column]
    
    C --> D[Row - Header]
    C --> E[Column - Content]
    C --> F[Row - Actions]
    
    D --> D1[CircleAvatar]
    D --> D2[Column - Name/Title]
    D --> D3[IconButton - Menu]
    
    E --> E1[Text - Bio]
    E --> E2[Row - Stats]
    
    F --> F1[ElevatedButton - Follow]
    F --> F2[OutlinedButton - Message]
    
    E2 --> E2A[StatColumn - Posts]
    E2 --> E2B[StatColumn - Followers]
    E2 --> E2C[StatColumn - Following]
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#e8eaf6
    style D fill:#e0f2f1
    style E fill:#fff8e1
    style F fill:#fce4ec
```

### Reusable Component Architecture
```mermaid
graph LR
    subgraph "Design System Components"
        A[BaseCard] --> B[ProfileCard]
        A --> C[ProductCard]
        A --> D[NewsCard]
        
        E[BaseButton] --> F[PrimaryButton]
        E --> G[SecondaryButton]
        E --> H[IconButton]
        
        I[BaseLayout] --> J[SingleColumn]
        I --> K[TwoColumn]
        I --> L[GridLayout]
    end
    
    subgraph "Composition"
        M[ComplexUI] --> B
        M --> F
        M --> J
        
        N[SimpleUI] --> C
        N --> G
        N --> K
    end
    
    style A fill:#e3f2fd
    style E fill:#e8f5e8
    style I fill:#fff3e0
    style M fill:#fce4ec
    style N fill:#f3e5f5
```

## 📊 Performance Optimization Flow

### Widget Rebuild Optimization
```mermaid
graph TD
    A[State Change] --> B{Widget Tree Analysis}
    
    B --> C[Identify Affected Widgets]
    C --> D{Widget Type}
    
    D -->|StatelessWidget| E[Check if props changed]
    D -->|StatefulWidget| F[Check if state changed]
    D -->|const Widget| G[Skip rebuild ✅]
    
    E -->|Props same| H[Skip rebuild ✅]
    E -->|Props changed| I[Rebuild required ⚠️]
    
    F -->|State same| J[Skip rebuild ✅]
    F -->|State changed| K[Rebuild required ⚠️]
    
    I --> L[Rebuild Widget & Children]
    K --> L
    
    L --> M[Layout & Paint]
    M --> N[Display Update]
    
    style G fill:#c8e6c9
    style H fill:#c8e6c9
    style J fill:#c8e6c9
    style I fill:#ffcdd2
    style K fill:#ffcdd2
    style L fill:#fff3e0
```

### Layout Performance Metrics
```mermaid
graph LR
    subgraph "Performance Indicators"
        A[Build Time<br/>< 16ms target]
        B[Layout Time<br/>< 2ms target]
        C[Paint Time<br/>< 4ms target]
        D[Memory Usage<br/>Minimal allocations]
    end
    
    subgraph "Optimization Strategies"
        E[const Constructors]
        F[Widget Extraction]
        G[RepaintBoundary]
        H[Efficient Builders]
    end
    
    A --> E
    B --> F
    C --> G
    D --> H
    
    subgraph "Monitoring Tools"
        I[Flutter Inspector]
        J[Performance Profiler]
        K[Memory Profiler]
        L[Timeline View]
    end
    
    A --> I
    B --> J
    C --> K
    D --> L
    
    style A fill:#e8f5e8
    style B fill:#fff3e0
    style C fill:#e3f2fd
    style D fill:#fce4ec
    style E fill:#c8e6c9
    style F fill:#c8e6c9
    style G fill:#c8e6c9
    style H fill:#c8e6c9
```

## 🎨 Design System Architecture

### Token-Based Design System
```mermaid
graph TD
    A[Design Tokens] --> B[Spacing Scale]
    A --> C[Color Palette]
    A --> D[Typography Scale]
    A --> E[Border Radius]
    A --> F[Shadow System]
    
    B --> B1[4pt Grid System<br/>4, 8, 12, 16, 20, 24...]
    C --> C1[Primary Colors<br/>Secondary Colors<br/>Semantic Colors]
    D --> D1[Font Sizes<br/>Line Heights<br/>Font Weights]
    E --> E1[Corner Radius<br/>2, 4, 8, 12, 16, 24px]
    F --> F1[Elevation Levels<br/>0, 2, 4, 8, 16, 24dp]
    
    subgraph "Component Implementation"
        G[Button Components]
        H[Card Components]
        I[Input Components]
        J[Layout Components]
    end
    
    B1 --> G
    C1 --> G
    D1 --> G
    E1 --> H
    F1 --> H
    
    style A fill:#e1f5fe
    style B1 fill:#e8f5e8
    style C1 fill:#fff3e0
    style D1 fill:#fce4ec
    style E1 fill:#f3e5f5
    style F1 fill:#e0f2f1
```

### Component Hierarchy
```mermaid
graph TD
    A[Atomic Components] --> B[Text]
    A --> C[Icon]
    A --> D[Button]
    A --> E[Input]
    
    F[Molecule Components] --> G[SearchBox]
    F --> H[Card Header]
    F --> I[Navigation Item]
    
    J[Organism Components] --> K[Navigation Bar]
    J --> L[Product Grid]
    J --> M[User Profile]
    
    N[Template Components] --> O[Dashboard Layout]
    N --> P[Article Layout]
    N --> Q[Settings Layout]
    
    B --> G
    C --> G
    E --> G
    
    G --> K
    H --> L
    I --> K
    
    K --> O
    L --> O
    M --> P
    
    style A fill:#e8f5e8
    style F fill:#fff3e0
    style J fill:#e3f2fd
    style N fill:#fce4ec
```

## 🔧 Debugging Layout Flow

### Layout Debugging Process
```mermaid
graph TD
    A[Layout Issue] --> B{Identify Problem Type}
    
    B -->|Overflow| C[RenderFlex Overflow]
    B -->|Sizing| D[Constraint Violation]
    B -->|Positioning| E[Stack/Alignment Issue]
    B -->|Performance| F[Rebuild Performance]
    
    C --> C1[Use Flexible/Expanded<br/>Add SingleChildScrollView<br/>Reduce fixed sizes]
    
    D --> D1[Check BoxConstraints<br/>Use LayoutBuilder<br/>Verify parent constraints]
    
    E --> E1[Check Stack children<br/>Verify Positioned values<br/>Use Align widget]
    
    F --> F1[Add const constructors<br/>Extract widgets<br/>Use RepaintBoundary]
    
    subgraph "Debugging Tools"
        G[Flutter Inspector<br/>Widget tree analysis]
        H[Layout Explorer<br/>Constraint visualization]
        I[Performance Tab<br/>Rebuild tracking]
        J[Memory Tab<br/>Widget allocation]
    end
    
    C1 --> G
    D1 --> H
    E1 --> G
    F1 --> I
    
    style C fill:#ffcdd2
    style D fill:#ffcdd2
    style E fill:#ffcdd2
    style F fill:#ffcdd2
    style C1 fill:#c8e6c9
    style D1 fill:#c8e6c9
    style E1 fill:#c8e6c9
    style F1 fill:#c8e6c9
```

### Common Layout Problems & Solutions
```mermaid
graph LR
    subgraph "Problem Categories"
        A[Overflow Errors]
        B[Unbounded Height]
        C[Constraint Conflicts]
        D[Performance Issues]
    end
    
    subgraph "Solutions"
        E[Flexible Layouts<br/>• Expanded<br/>• Flexible<br/>• Scrollable]
        
        F[Bounded Containers<br/>• SizedBox<br/>• Container<br/>• AspectRatio]
        
        G[Constraint Management<br/>• LayoutBuilder<br/>• MediaQuery<br/>• IntrinsicHeight]
        
        H[Optimization<br/>• const widgets<br/>• Widget extraction<br/>• RepaintBoundary]
    end
    
    A --> E
    B --> F
    C --> G
    D --> H
    
    style A fill:#ffebee
    style B fill:#ffebee
    style C fill:#ffebee
    style D fill:#ffebee
    style E fill:#e8f5e8
    style F fill:#e8f5e8
    style G fill:#e8f5e8
    style H fill:#e8f5e8
```

---

**💡 Visual Learning Note**: These diagrams illustrate the complex relationships and algorithms that power Flutter's layout system. Understanding these visual patterns will help you reason about layout behavior and debug issues more effectively. Use them as reference when implementing advanced layout patterns in your applications.