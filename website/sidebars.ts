import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

/**
 * ULTRA-SIMPLE SIDEBAR - JUST LESSONS
 * No complex grouping, no phases, just direct lesson access
 */
const sidebars: SidebarsConfig = {
  tutorialSidebar: [
    'intro',
    'course-overview',
    
    // Lessons 1-26 - Simple and Direct
    {
      type: 'category',
      label: '🚀 Lesson 01: Introduction to Flutter',
      collapsed: true,
      items: [
        'lessons/lesson-01/index',
        'lessons/lesson-01/concept',
        'lessons/lesson-01/workshop_01',
        'lessons/lesson-01/diagram',
      ],
    },
    {
      type: 'category',
      label: '🛠️ Lesson 02: Development Environment Setup',
      collapsed: true,
      items: [
        'lessons/lesson-02/index',
        'lessons/lesson-02/concept',
        'lessons/lesson-02/workshop_02',
        'lessons/lesson-02/diagram',
      ],
    },
    {
      type: 'category',
      label: '📝 Lesson 03: Dart Fundamentals',
      collapsed: true,
      items: [
        'lessons/lesson-03/index',
        'lessons/lesson-03/concept',
        'lessons/lesson-03/workshop_03',
        'lessons/lesson-03/diagram',
      ],
    },
    {
      type: 'category',
      label: '🧩 Lesson 04: Widgets 101',
      collapsed: true,
      items: [
        'lessons/lesson-04/index',
        'lessons/lesson-04/concept',
        'lessons/lesson-04/workshop_04',
        'lessons/lesson-04/diagram',
      ],
    },
    {
      type: 'category',
      label: '🎨 Lesson 05: Layouts & UI Composition',
      collapsed: true,
      items: [
        'lessons/lesson-05/index',
        'lessons/lesson-05/concept',
        'lessons/lesson-05/workshop_05',
        'lessons/lesson-05/diagram',
      ],
    },
    {
      type: 'category',
      label: '🧭 Lesson 06: Navigation & Routing',
      collapsed: true,
      items: [
        'lessons/lesson-06/index',
        'lessons/lesson-06/concept',
        'lessons/lesson-06/workshop_06',
        'lessons/lesson-06/diagram',
      ],
    },
    {
      type: 'category',
      label: '🎭 Lesson 07: Theming Your App',
      collapsed: true,
      items: [
        'lessons/lesson-07/index',
        'lessons/lesson-07/concept',
        'lessons/lesson-07/workshop_07',
        'lessons/lesson-07/workshop_07_part2',
        'lessons/lesson-07/workshop_07_part3',
        'lessons/lesson-07/diagram',
      ],
    },
    {
      type: 'category',
      label: '📱 Lesson 08: Responsive Design',
      collapsed: true,
      items: [
        'lessons/lesson-08/index',
        'lessons/lesson-08/concept',
        'lessons/lesson-08/workshop_08',
        'lessons/lesson-08/workshop_08_part2',
        'lessons/lesson-08/diagram',
      ],
    },
    {
      type: 'category',
      label: '🎛️ Lesson 09: Forms & User Input',
      collapsed: true,
      items: [
        'lessons/lesson-09/index',
        'lessons/lesson-09/concept',
        'lessons/lesson-09/workshop_09',
        'lessons/lesson-09/workshop_09_part2',
        'lessons/lesson-09/diagram',
      ],
    },
    {
      type: 'category',
      label: '🔄 Lesson 10: setState & Stateful Widgets',
      collapsed: true,
      items: [
        'lessons/lesson-10/index',
        'lessons/lesson-10/concept',
        'lessons/lesson-10/workshop_10',
        'lessons/lesson-10/workshop_10_part2',
        'lessons/lesson-10/diagram',
      ],
    },
    {
      type: 'category',
      label: '🗃️ Lesson 11: Provider Pattern',
      collapsed: true,
      items: [
        'lessons/lesson-11/index',
        'lessons/lesson-11/concept',
        'lessons/lesson-11/workshop_11',
        'lessons/lesson-11/workshop_11_part2',
        'lessons/lesson-11/diagram',
      ],
    },
    {
      type: 'category',
      label: '🏗️ Lesson 12: Bloc Pattern',
      collapsed: true,
      items: [
        'lessons/lesson-12/index',
        'lessons/lesson-12/concept',
        'lessons/lesson-12/workshop_12',
        'lessons/lesson-12/workshop_12_part2',
        'lessons/lesson-12/diagram',
      ],
    },
    {
      type: 'category',
      label: '⚡ Lesson 13: Riverpod',
      collapsed: true,
      items: [
        'lessons/lesson-13/index',
        'lessons/lesson-13/concept',
        'lessons/lesson-13/workshop_13',
        'lessons/lesson-13/workshop_13_part2',
        'lessons/lesson-13/diagram',
      ],
    },
    {
      type: 'category',
      label: '🎯 Lesson 14: State Management Decision Framework',
      collapsed: true,
      items: [
        'lessons/lesson-14/index',
        'lessons/lesson-14/concept',
        'lessons/lesson-14/workshop_14',
      ],
    },
    {
      type: 'category',
      label: '🚀 Lesson 15: AuthFlow Pro - Hybrid Architecture',
      collapsed: true,
      items: [
        'lessons/lesson-15/index',
        'lessons/lesson-15/concept',
        'lessons/lesson-15/workshop_15',
        'lessons/lesson-15/diagram',
      ],
    },
    {
      type: 'category',
      label: '🌐 Lesson 16: Networking with Dio & Retrofit',
      collapsed: true,
      items: [
        'lessons/lesson-16/index',
        'lessons/lesson-16/concept',
        'lessons/lesson-16/workshop_16',
        'lessons/lesson-16/diagram',
      ],
    },
    {
      type: 'category',
      label: '💾 Lesson 17: Local Storage (Hive/SQLite)',
      collapsed: true,
      items: [
        'lessons/lesson-17/index',
        'lessons/lesson-17/concept',
        'lessons/lesson-17/workshop_17',
        'lessons/lesson-17/diagram',
      ],
    },
    {
      type: 'category',
      label: '📊 Lesson 18: NewsHub Ultimate - Data Integration',
      collapsed: true,
      items: [
        'lessons/lesson-18/index',
        'lessons/lesson-18/concept',
        'lessons/lesson-18/workshop_18',
      ],
    },
    {
      type: 'category',
      label: '🔐 Lesson 19: Firebase Auth + Firestore',
      collapsed: true,
      items: [
        'lessons/lesson-19/index',
        'lessons/lesson-19/concept',
        'lessons/lesson-19/workshop_19',
        'lessons/lesson-19/diagram',
      ],
    },
    {
      type: 'category',
      label: '☁️ Lesson 20: Cloud Functions + Push Notifications',
      collapsed: true,
      items: [
        'lessons/lesson-20/index',
        'lessons/lesson-20/concept',
        'lessons/lesson-20/workshop_20',
        'lessons/lesson-20/diagram',
      ],
    },
    {
      type: 'category',
      label: '🌟 Lesson 21: ConnectPro Ultimate - Social Platform',
      collapsed: true,
      items: [
        'lessons/lesson-21/index',
        'lessons/lesson-21/concept',
        'lessons/lesson-21/workshop_21',
        'lessons/lesson-21/diagram',
      ],
    },
    {
      type: 'category',
      label: '🧪 Lesson 22: Unit & Widget Testing',
      collapsed: true,
      items: [
        'lessons/lesson-22/index',
        'lessons/lesson-22/concept',
        'lessons/lesson-22/workshop_22',
        'lessons/lesson-22/diagram',
      ],
    },
    {
      type: 'category',
      label: '🔍 Lesson 23: Integration Testing + Mocking',
      collapsed: true,
      items: [
        'lessons/lesson-23/index',
        'lessons/lesson-23/concept',
        'lessons/lesson-23/workshop_23',
        'lessons/lesson-23/diagram',
      ],
    },
    {
      type: 'category',
      label: '📈 Lesson 24: Error Handling & Logging',
      collapsed: true,
      items: [
        'lessons/lesson-24/index',
        'lessons/lesson-24/concept',
        'lessons/lesson-24/workshop_24',
        'lessons/lesson-24/diagram',
      ],
    },
    {
      type: 'category',
      label: '🚀 Lesson 25: CI/CD with GitHub Actions',
      collapsed: true,
      items: [
        'lessons/lesson-25/index',
        'lessons/lesson-25/concept',
        'lessons/lesson-25/workshop_25',
        'lessons/lesson-25/diagram',
      ],
    },
    {
      type: 'category',
      label: '📱 Lesson 26: App Store Deployment',
      collapsed: true,
      items: [
        'lessons/lesson-26/index',
        'lessons/lesson-26/concept',
        'lessons/lesson-26/workshop_26',
        'lessons/lesson-26/diagram',
      ],
    },
  ],
};

export default sidebars;