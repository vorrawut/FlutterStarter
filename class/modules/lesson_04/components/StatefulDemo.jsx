import { useState } from 'react';

export const StatefulDemo = () => {
  const [count, setCount] = useState(0);
  const [isStateless, setIsStateless] = useState(true);

  return (
    <div style={{
      padding: '20px',
      backgroundColor: '#f8f9fa',
      borderRadius: '8px',
      textAlign: 'center'
    }}>
      <h4 style={{ margin: '0 0 20px 0', color: '#2e3440' }}>💡 StatelessWidget vs StatefulWidget</h4>

      <div style={{ display: 'flex', gap: '20px', justifyContent: 'center' }}>
        <div style={{
          padding: '20px',
          backgroundColor: isStateless ? '#e3f2fd' : '#fff',
          border: isStateless ? '2px solid #2196f3' : '2px solid #e5e7eb',
          borderRadius: '8px',
          cursor: 'pointer',
          minWidth: '150px'
        }}
        onClick={() => setIsStateless(true)}
        >
          <div style={{ fontSize: '24px', marginBottom: '10px' }}>🖼️</div>
          <div style={{ fontWeight: 'bold', color: '#1f2937' }}>StatelessWidget</div>
          <div style={{ fontSize: '12px', color: '#64748b', marginTop: '5px' }}>Never changes</div>
          <div style={{
            marginTop: '10px',
            padding: '8px',
            backgroundColor: '#f3f4f6',
            borderRadius: '4px',
            fontSize: '14px'
          }}>
            "Welcome!"
          </div>
        </div>

        <div style={{
          padding: '20px',
          backgroundColor: !isStateless ? '#e8f5e8' : '#fff',
          border: !isStateless ? '2px solid #4caf50' : '2px solid #e5e7eb',
          borderRadius: '8px',
          cursor: 'pointer',
          minWidth: '150px'
        }}
        onClick={() => setIsStateless(false)}
        >
          <div style={{ fontSize: '24px', marginBottom: '10px' }}>💡</div>
          <div style={{ fontWeight: 'bold', color: '#1f2937' }}>StatefulWidget</div>
          <div style={{ fontSize: '12px', color: '#64748b', marginTop: '5px' }}>Can change</div>
          <div style={{
            marginTop: '10px',
            padding: '8px',
            backgroundColor: '#f3f4f6',
            borderRadius: '4px',
            fontSize: '14px'
          }}>
            Count: {count}
            <br/>
            <button
              onClick={(e) => {
                e.stopPropagation();
                setCount(count + 1);
              }}
              style={{
                marginTop: '8px',
                padding: '4px 8px',
                border: 'none',
                borderRadius: '4px',
                backgroundColor: '#4caf50',
                color: 'white',
                cursor: 'pointer',
                fontSize: '12px'
              }}
            >
              Add 1
            </button>
          </div>
        </div>
      </div>

      <div style={{ marginTop: '20px', fontSize: '12px', color: '#64748b' }}>
        💡 Click on each type to see the difference! Try clicking "Add 1" on the StatefulWidget.
      </div>
    </div>
  );
};