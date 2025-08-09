import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  tutorialSidebar: [
    'intro',
    'course-overview',
    {
      type: 'category',
      label: '🟢 Phase 1: Foundation',
      collapsed: false,
      items: [
        'lessons/lesson-01/index',
        'lessons/lesson-02/index',
        'lessons/lesson-03/index',
        'lessons/lesson-04/index',
        'lessons/lesson-05/index',
      ],
    },
    {
      type: 'category',
      label: '🔵 Phase 2: UI Mastery',
      collapsed: true,
      items: [
        'lessons/lesson-06/index',
        'lessons/lesson-07/index',
        'lessons/lesson-08/index',
        'lessons/lesson-09/index',
      ],
    },
    {
      type: 'category',
      label: '🟡 Phase 3: State Management',
      collapsed: true,
      items: [
        'lessons/lesson-10/index',
        'lessons/lesson-11/index',
        'lessons/lesson-12/index',
        'lessons/lesson-13/index',
        'lessons/lesson-14/index',
        'lessons/lesson-15/index',
      ],
    },
    {
      type: 'category',
      label: '🟠 Phase 4: Data & Storage',
      collapsed: true,
      items: [
        'lessons/lesson-16/index',
        'lessons/lesson-17/index',
        'lessons/lesson-18/index',
      ],
    },
    {
      type: 'category',
      label: '🔴 Phase 5: Firebase & Cloud',
      collapsed: true,
      items: [
        'lessons/lesson-19/index',
        'lessons/lesson-20/index',
        'lessons/lesson-21/index',
      ],
    },
    {
      type: 'category',
      label: '🟣 Phase 6: Production Ready',
      collapsed: true,
      items: [
        'lessons/lesson-22/index',
        'lessons/lesson-23/index',
        'lessons/lesson-24/index',
        'lessons/lesson-25/index',
        'lessons/lesson-26/index',
      ],
    },
  ],
};

export default sidebars;
