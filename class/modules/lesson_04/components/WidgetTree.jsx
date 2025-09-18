import { useState } from 'react';

export const WidgetTree = () => {
  const [selectedWidget, setSelectedWidget] = useState(null);
  const [hoveredWidget, setHoveredWidget] = useState(null);

  const widgets = [
    {
      id: 'myapp',
      name: 'MyApp',
      level: 0,
      icon: '🏠',
      description: 'The very top of your app - like the main building that contains everything',
      type: 'App',
      phoneArea: 'whole'
    },
    {
      id: 'materialapp',
      name: 'MaterialApp',
      level: 1,
      icon: '🎨',
      description: 'Adds Google Material Design styling to make your app look modern',
      type: 'Theme',
      phoneArea: 'whole'
    },
    {
      id: 'scaffold',
      name: 'Scaffold',
      level: 2,
      icon: '🏗️',
      description: 'Creates the basic page structure with space for AppBar and body content',
      type: 'Layout',
      phoneArea: 'whole'
    },
    {
      id: 'appbar',
      name: 'AppBar',
      level: 3,
      icon: '📋',
      description: 'The blue top bar where you put your app title and navigation buttons',
      type: 'UI',
      phoneArea: 'appbar'
    },
    {
      id: 'appbar-text',
      name: 'Text',
      level: 4,
      icon: '📝',
      description: 'Shows the title "My First App" in the top bar',
      type: 'Content',
      phoneArea: 'appbar'
    },
    {
      id: 'center',
      name: 'Center',
      level: 3,
      icon: '🎯',
      description: 'Puts whatever is inside it right in the middle of the screen',
      type: 'Layout',
      phoneArea: 'body'
    },
    {
      id: 'center-text',
      name: 'Text',
      level: 4,
      icon: '📝',
      description: 'Shows "Hello, World!" in the center of the screen',
      type: 'Content',
      phoneArea: 'body'
    }
  ];

  const getTypeColor = (type) => {
    const colors = {
      'App': '#8b5cf6',
      'Theme': '#f59e0b',
      'Layout': '#059669',
      'UI': '#2196f3',
      'Content': '#dc2626'
    };
    return colors[type] || '#64748b';
  };

  const getConnectorStyle = (level, isLast) => {
    if (level === 0) return '';

    let connector = '';
    for (let i = 1; i < level; i++) {
      connector += '│   ';
    }
    connector += isLast ? '└── ' : '├── ';
    return connector;
  };

  const isLastAtLevel = (widgets, currentIndex, level) => {
    for (let i = currentIndex + 1; i < widgets.length; i++) {
      if (widgets[i].level <= level) {
        return widgets[i].level < level;
      }
    }
    return true;
  };

  const getPhoneAreaStyle = (phoneArea, isSelected, isHovered) => {
    const baseStyle = {
      transition: 'all 0.3s ease',
      cursor: 'pointer'
    };

    if (isSelected) {
      return {
        ...baseStyle,
        backgroundColor: '#e3f2fd',
        border: '2px solid #2196f3',
        boxShadow: '0 0 10px rgba(33, 150, 243, 0.3)'
      };
    }

    if (isHovered) {
      return {
        ...baseStyle,
        backgroundColor: '#f8fafc',
        border: '2px solid #94a3b8'
      };
    }

    return baseStyle;
  };

  return (
    <div style={{
      backgroundColor: '#f8f9fa',
      padding: '20px',
      borderRadius: '12px',
      fontFamily: 'system-ui, -apple-system, sans-serif',
      fontSize: '14px',
      border: '1px solid #e5e7eb'
    }}>
      <div style={{
        display: 'flex',
        alignItems: 'center',
        gap: '10px',
        marginBottom: '20px'
      }}>
        <h4 style={{ margin: '0', color: '#2e3440' }}>📱 Widget Tree → Phone Screen</h4>
        <div style={{
          fontSize: '11px',
          color: '#64748b',
          backgroundColor: '#fff',
          padding: '4px 8px',
          borderRadius: '12px',
          border: '1px solid #e5e7eb'
        }}>
          Click widgets to see them on phone!
        </div>
      </div>

      <div style={{ display: 'flex', gap: '30px', alignItems: 'flex-start' }}>
        {/* Widget Tree */}
        <div style={{ flex: 1, minWidth: '300px' }}>
          <div style={{
            backgroundColor: '#fff',
            padding: '15px',
            borderRadius: '8px',
            border: '1px solid #e5e7eb'
          }}>
            <div style={{
              fontSize: '12px',
              fontWeight: '600',
              color: '#64748b',
              marginBottom: '10px',
              borderBottom: '1px solid #e5e7eb',
              paddingBottom: '8px'
            }}>
              🌳 Widget Hierarchy
            </div>
            {widgets.map((widget, index) => {
              const isSelected = selectedWidget === widget.id;
              const isHovered = hoveredWidget === widget.id;
              const isLast = isLastAtLevel(widgets, index, widget.level);

              return (
                <div key={widget.id}>
                  <div
                    style={{
                      padding: '6px 10px',
                      margin: '1px 0',
                      cursor: 'pointer',
                      backgroundColor: isSelected ? '#e3f2fd' : isHovered ? '#f8fafc' : 'transparent',
                      borderRadius: '6px',
                      border: isSelected ? '2px solid #2196f3' : '2px solid transparent',
                      transition: 'all 0.2s ease',
                      position: 'relative'
                    }}
                    onClick={() => setSelectedWidget(isSelected ? null : widget.id)}
                    onMouseEnter={() => setHoveredWidget(widget.id)}
                    onMouseLeave={() => setHoveredWidget(null)}
                  >
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <span style={{
                        color: '#94a3b8',
                        fontFamily: 'monospace',
                        fontSize: '11px',
                        minWidth: `${widget.level * 16 + 30}px`
                      }}>
                        {getConnectorStyle(widget.level, isLast)}
                      </span>

                      <span style={{ fontSize: '14px' }}>{widget.icon}</span>

                      <span style={{
                        color: getTypeColor(widget.type),
                        fontWeight: '600',
                        fontSize: '12px'
                      }}>
                        {widget.name}
                      </span>

                      <div style={{
                        fontSize: '8px',
                        color: getTypeColor(widget.type),
                        backgroundColor: `${getTypeColor(widget.type)}15`,
                        padding: '1px 4px',
                        borderRadius: '6px',
                        fontWeight: '500'
                      }}>
                        {widget.type}
                      </div>
                    </div>

                    {isSelected && (
                      <div style={{
                        marginTop: '6px',
                        padding: '8px',
                        backgroundColor: '#f8fafc',
                        borderRadius: '4px',
                        fontSize: '11px',
                        color: '#475569',
                        borderLeft: `2px solid ${getTypeColor(widget.type)}`,
                        lineHeight: '1.3'
                      }}>
                        <div style={{
                          fontWeight: '600',
                          marginBottom: '3px',
                          color: getTypeColor(widget.type)
                        }}>
                          {widget.name}
                        </div>
                        {widget.description}
                      </div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Phone Preview */}
        <div style={{ flex: 0, flexShrink: 0 }}>
          <div style={{
            fontSize: '12px',
            fontWeight: '600',
            color: '#64748b',
            marginBottom: '10px',
            textAlign: 'center'
          }}>
            📱 How it looks on phone
          </div>

          {/* Phone Frame */}
          <div style={{
            width: '200px',
            height: '360px',
            backgroundColor: '#000',
            borderRadius: '24px',
            padding: '12px',
            boxShadow: '0 10px 30px rgba(0,0,0,0.2)'
          }}>
            {/* Phone Screen */}
            <div style={{
              width: '100%',
              height: '100%',
              backgroundColor: '#fff',
              borderRadius: '16px',
              overflow: 'hidden',
              display: 'flex',
              flexDirection: 'column',
              position: 'relative',
              ...getPhoneAreaStyle(
                'whole',
                ['myapp', 'materialapp', 'scaffold'].includes(selectedWidget),
                ['myapp', 'materialapp', 'scaffold'].includes(hoveredWidget)
              )
            }}
            onClick={() => {
              if (['myapp', 'materialapp', 'scaffold'].includes(selectedWidget)) {
                setSelectedWidget(null);
              }
            }}
            >
              {/* AppBar */}
              <div style={{
                backgroundColor: '#2196f3',
                color: 'white',
                padding: '12px',
                fontSize: '14px',
                fontWeight: 'bold',
                textAlign: 'center',
                ...getPhoneAreaStyle(
                  'appbar',
                  ['appbar', 'appbar-text'].includes(selectedWidget),
                  ['appbar', 'appbar-text'].includes(hoveredWidget)
                )
              }}
              onClick={(e) => {
                e.stopPropagation();
                if (['appbar', 'appbar-text'].includes(selectedWidget)) {
                  setSelectedWidget(null);
                } else {
                  setSelectedWidget('appbar');
                }
              }}
              >
                {['appbar-text'].includes(selectedWidget) && (
                  <div style={{
                    position: 'absolute',
                    top: '0',
                    left: '0',
                    right: '0',
                    bottom: '0',
                    backgroundColor: 'rgba(220, 38, 38, 0.2)',
                    pointerEvents: 'none'
                  }} />
                )}
                My First App
              </div>

              {/* Body */}
              <div style={{
                flex: 1,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '14px',
                position: 'relative',
                ...getPhoneAreaStyle(
                  'body',
                  ['center', 'center-text'].includes(selectedWidget),
                  ['center', 'center-text'].includes(hoveredWidget)
                )
              }}
              onClick={(e) => {
                e.stopPropagation();
                if (['center', 'center-text'].includes(selectedWidget)) {
                  setSelectedWidget(null);
                } else {
                  setSelectedWidget('center');
                }
              }}
              >
                {['center-text'].includes(selectedWidget) && (
                  <div style={{
                    position: 'absolute',
                    top: '40%',
                    left: '30%',
                    right: '30%',
                    bottom: '40%',
                    backgroundColor: 'rgba(220, 38, 38, 0.3)',
                    borderRadius: '4px',
                    pointerEvents: 'none',
                    border: '1px dashed #dc2626'
                  }} />
                )}
                <div style={{
                  textAlign: 'center'
                }}>
                  <div style={{ marginBottom: '15px', fontSize: '16px' }}>📱 "Hello, World!"</div>
                  <button style={{
                    padding: '8px 16px',
                    backgroundColor: '#2196f3',
                    color: 'white',
                    border: 'none',
                    borderRadius: '6px',
                    fontSize: '12px',
                    cursor: 'pointer'
                  }}>
                    Click Me
                  </button>
                  <div style={{ marginTop: '15px', fontSize: '18px' }}>⭐ ⭐ ⭐</div>
                </div>
              </div>
            </div>
          </div>

          {/* Helper text */}
          <div style={{
            marginTop: '10px',
            fontSize: '10px',
            color: '#64748b',
            textAlign: 'center',
            lineHeight: '1.3'
          }}>
            {selectedWidget && (
              <div style={{
                backgroundColor: '#fff',
                padding: '6px',
                borderRadius: '4px',
                border: '1px solid #e5e7eb'
              }}>
                <strong style={{ color: getTypeColor(widgets.find(w => w.id === selectedWidget)?.type) }}>
                  {widgets.find(w => w.id === selectedWidget)?.name}
                </strong> is highlighted above
              </div>
            )}
            {!selectedWidget && (
              <div>Click widgets on the left to see them highlighted on the phone!</div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};