# 📜 Diagram

## 🏗️ Flutter Layout System Architecture

### Constraint-Based Layout Flow
![box_constrain.png](images/box_constrain.png)

## 📱 Responsive Design Breakpoints

### Screen Size Categories
![what_is_responsive_web.png](images/what_is_responsive_web.png)

![iphone_screen_resolution.jpg](images/iphone_screen_resolution.jpg)

![foldable_1.webp](images/foldable_1.webp)

![foldable_3.jpg](images/foldable_3.jpg)

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
