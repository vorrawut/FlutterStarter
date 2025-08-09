import React from 'react';
import Layout from '@theme-original/Layout';
import AutoExpandSidebar from '@site/src/components/AutoExpandSidebar';

export default function LayoutWrapper(props) {
  return (
    <>
      <Layout {...props} />
      <AutoExpandSidebar />
    </>
  );
}
