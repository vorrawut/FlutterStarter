import { useState } from 'react';

export const WidgetComposition = () => {
  const [activeStep, setActiveStep] = useState(0);

  const steps = [
    {
      title: "1. Start with Container",
      description: "A utility widget that creates a box",
      component: (
        <div style={{
          border: '2px dashed #8b5cf6',
          padding: '20px',
          borderRadius: '8px',
          backgroundColor: '#f3f4f6'
        }}>
          <span style={{ color: '#8b5cf6', fontWeight: 'bold' }}>🧱 Container</span>
        </div>
      )
    },
    {
      title: "2. Add Row layout",
      description: "Layout widget arranges items side by side",
      component: (
        <div style={{
          border: '2px dashed #8b5cf6',
          padding: '20px',
          borderRadius: '8px',
          backgroundColor: '#f3f4f6'
        }}>
          <span style={{ color: '#8b5cf6', fontWeight: 'bold' }}>🧱 Container</span>
          <div style={{
            border: '2px dashed #059669',
            padding: '15px',
            margin: '10px 0',
            borderRadius: '6px',
            display: 'flex',
            alignItems: 'center',
            gap: '10px'
          }}>
            <span style={{ color: '#059669', fontWeight: 'bold' }}>🧱 Row</span>
            <span style={{ fontSize: '12px', color: '#64748b' }}>(arranges side by side →)</span>
          </div>
        </div>
      )
    },
    {
      title: "3. Add visual widgets",
      description: "Icon and Text widgets show content",
      component: (
        <div style={{
          border: '2px dashed #8b5cf6',
          padding: '20px',
          borderRadius: '8px',
          backgroundColor: '#f3f4f6'
        }}>
          <span style={{ color: '#8b5cf6', fontWeight: 'bold' }}>🧱 Container</span>
          <div style={{
            border: '2px dashed #059669',
            padding: '15px',
            margin: '10px 0',
            borderRadius: '6px',
            display: 'flex',
            alignItems: 'center',
            gap: '10px'
          }}>
            <span style={{ color: '#059669', fontWeight: 'bold' }}>🧱 Row</span>
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              padding: '8px',
              backgroundColor: '#fff',
              borderRadius: '4px',
              border: '1px solid #e5e7eb'
            }}>
              <span style={{ fontSize: '16px' }}>⭐</span>
              <span style={{ color: '#1f2937' }}>Rating: 5</span>
            </div>
          </div>
        </div>
      )
    }
  ];

  return (
    <div style={{ padding: '20px', backgroundColor: '#f8f9fa', borderRadius: '8px' }}>
      <h4 style={{ margin: '0 0 20px 0', color: '#2e3440' }}>🔧 Widget Composition Builder</h4>

      <div style={{ display: 'flex', gap: '10px', marginBottom: '20px' }}>
        {steps.map((step, index) => (
          <button
            key={index}
            onClick={() => setActiveStep(index)}
            style={{
              padding: '8px 16px',
              border: 'none',
              borderRadius: '6px',
              backgroundColor: activeStep === index ? '#2196f3' : '#e5e7eb',
              color: activeStep === index ? 'white' : '#374151',
              cursor: 'pointer',
              fontSize: '12px',
              fontWeight: '500'
            }}
          >
            Step {index + 1}
          </button>
        ))}
      </div>

      <div style={{ minHeight: '200px' }}>
        <h5 style={{ color: '#1f2937', marginBottom: '10px' }}>
          {steps[activeStep].title}
        </h5>
        <p style={{ color: '#64748b', fontSize: '14px', marginBottom: '15px' }}>
          {steps[activeStep].description}
        </p>
        {steps[activeStep].component}
      </div>

      <div style={{ marginTop: '15px', fontSize: '12px', color: '#64748b' }}>
        💡 Click through the steps to see how widgets build up!
      </div>
    </div>
  );
};