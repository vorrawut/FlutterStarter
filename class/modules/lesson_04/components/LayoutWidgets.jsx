import { useState } from 'react';

export const LayoutWidgets = () => {
  const [selectedWidget, setSelectedWidget] = useState('row');

  const widgets = {
    row: {
      title: "Row - Side by Side →→→",
      description: "Arranges widgets horizontally (left to right)",
      icon: "➡️",
      example: (
        <div style={{
          display: 'flex',
          flexDirection: 'row',
          alignItems: 'center',
          gap: '10px',
          padding: '20px',
          backgroundColor: '#fff3cd',
          border: '2px dashed #f59e0b',
          borderRadius: '8px',
          minHeight: '60px'
        }}>
          <div style={{
            padding: '8px 12px',
            backgroundColor: '#3b82f6',
            color: 'white',
            borderRadius: '4px',
            fontSize: '14px'
          }}>Widget 1</div>
          <div style={{
            padding: '8px 12px',
            backgroundColor: '#10b981',
            color: 'white',
            borderRadius: '4px',
            fontSize: '14px'
          }}>Widget 2</div>
          <div style={{
            padding: '8px 12px',
            backgroundColor: '#f59e0b',
            color: 'white',
            borderRadius: '4px',
            fontSize: '14px'
          }}>Widget 3</div>
        </div>
      ),
      code: `Row(
  children: [
    Text('Widget 1'),
    Text('Widget 2'),
    Text('Widget 3'),
  ],
)`
    },
    column: {
      title: "Column - Top to Bottom ↓↓↓",
      description: "Arranges widgets vertically (top to bottom)",
      icon: "⬇️",
      example: (
        <div style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          gap: '10px',
          padding: '20px',
          backgroundColor: '#dcfce7',
          border: '2px dashed #10b981',
          borderRadius: '8px',
          minHeight: '140px'
        }}>
          <div style={{
            padding: '8px 12px',
            backgroundColor: '#3b82f6',
            color: 'white',
            borderRadius: '4px',
            fontSize: '14px'
          }}>Widget 1</div>
          <div style={{
            padding: '8px 12px',
            backgroundColor: '#10b981',
            color: 'white',
            borderRadius: '4px',
            fontSize: '14px'
          }}>Widget 2</div>
          <div style={{
            padding: '8px 12px',
            backgroundColor: '#f59e0b',
            color: 'white',
            borderRadius: '4px',
            fontSize: '14px'
          }}>Widget 3</div>
        </div>
      ),
      code: `Column(
  children: [
    Text('Widget 1'),
    Text('Widget 2'),
    Text('Widget 3'),
  ],
)`
    },
    padding: {
      title: "Padding - Adds Space Around Things",
      description: "Creates space around a widget for better layout",
      icon: "📏",
      example: (
        <div style={{
          padding: '20px',
          backgroundColor: '#f3e8ff',
          border: '2px dashed #8b5cf6',
          borderRadius: '8px',
          minHeight: '100px',
          position: 'relative'
        }}>
          <div style={{
            position: 'absolute',
            top: '5px',
            left: '5px',
            fontSize: '12px',
            color: '#8b5cf6',
            fontWeight: 'bold'
          }}>Padding: 20px</div>
          <div style={{
            padding: '15px',
            backgroundColor: '#3b82f6',
            color: 'white',
            borderRadius: '4px',
            fontSize: '14px',
            textAlign: 'center',
            margin: '15px'
          }}>My Widget</div>
        </div>
      ),
      code: `Padding(
  padding: EdgeInsets.all(20),
  child: Text('My Widget'),
)`
    }
  };

  return (
    <div style={{ padding: '20px', backgroundColor: '#f8f9fa', borderRadius: '8px' }}>
      <h4 style={{ margin: '0 0 20px 0', color: '#2e3440' }}>🧱 Layout Widgets Explorer</h4>

      {/* Widget Selector */}
      <div style={{ display: 'flex', gap: '10px', marginBottom: '20px', flexWrap: 'wrap' }}>
        {Object.entries(widgets).map(([key, widget]) => (
          <button
            key={key}
            onClick={() => setSelectedWidget(key)}
            style={{
              padding: '10px 16px',
              border: 'none',
              borderRadius: '8px',
              backgroundColor: selectedWidget === key ? '#2196f3' : '#e5e7eb',
              color: selectedWidget === key ? 'white' : '#374151',
              cursor: 'pointer',
              fontSize: '13px',
              fontWeight: '500',
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              transition: 'all 0.2s'
            }}
            onMouseEnter={(e) => {
              if (selectedWidget !== key) {
                e.target.style.backgroundColor = '#d1d5db';
              }
            }}
            onMouseLeave={(e) => {
              if (selectedWidget !== key) {
                e.target.style.backgroundColor = '#e5e7eb';
              }
            }}
          >
            <span>{widgets[key].icon}</span>
            {key.charAt(0).toUpperCase() + key.slice(1)}
          </button>
        ))}
      </div>

      {/* Selected Widget Display */}
      <div style={{ minHeight: '250px' }}>
        <div style={{ marginBottom: '15px' }}>
          <h5 style={{
            color: '#1f2937',
            marginBottom: '5px',
            display: 'flex',
            alignItems: 'center',
            gap: '8px'
          }}>
            <span style={{ fontSize: '20px' }}>{widgets[selectedWidget].icon}</span>
            {widgets[selectedWidget].title}
          </h5>
          <p style={{ color: '#64748b', fontSize: '14px', margin: '0 0 15px 0' }}>
            {widgets[selectedWidget].description}
          </p>
        </div>

        {/* Visual Example */}
        <div style={{ marginBottom: '15px' }}>
          <div style={{
            fontSize: '14px',
            fontWeight: '600',
            color: '#374151',
            marginBottom: '8px'
          }}>
            📱 Visual Example:
          </div>
          {widgets[selectedWidget].example}
        </div>

        {/* Code Example */}
        <div style={{ marginBottom: '15px' }}>
          <div style={{
            fontSize: '14px',
            fontWeight: '600',
            color: '#374151',
            marginBottom: '8px'
          }}>
            💻 Flutter Code:
          </div>
          <pre style={{
            backgroundColor: '#1f2937',
            color: '#f3f4f6',
            padding: '12px',
            borderRadius: '6px',
            fontSize: '13px',
            margin: '0',
            overflow: 'auto',
            fontFamily: 'Monaco, Consolas, "Liberation Mono", "Courier New", monospace'
          }}>
            {widgets[selectedWidget].code}
          </pre>
        </div>
      </div>

      <div style={{
        marginTop: '15px',
        fontSize: '12px',
        color: '#64748b',
        fontStyle: 'italic'
      }}>
        💡 Click the buttons above to explore different layout widgets!
      </div>
    </div>
  );
};