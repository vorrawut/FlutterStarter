/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */

// @ts-check

/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {
  tutorialSidebar: [
    'README',
    'COURSE_OVERVIEW',
    {
      type: 'category',
      label: '🟢 Phase 1: Foundation',
      collapsed: false,
      items: [
        {
          type: 'category',
          label: '🚀 Lesson 01: Introduction to Flutter',
          items: [
            'modules/lesson_01/concept',
          ],
        },
        {
          type: 'category',
          label: '🛠️ Lesson 02: Development Environment Setup',
          items: [
            'modules/lesson_02/concept',
            // 'modules/lesson_02/workshop_02',
            // 'modules/lesson_02/diagram',
          ],
        },
        {
          type: 'category',
          label: '📝 Lesson 03: Dart Fundamentals',
          items: [
            'modules/lesson_03/concept',
          ],
        },
        {
          type: 'category',
          label: '🧩 Lesson 04: Widgets 101',
          items: [
            'modules/lesson_04/concept',
          ],
        },
        {
          type: 'category',
          label: '🎨 Lesson 05: Layouts & UI Composition',
          items: [
            'modules/lesson_05/diagram',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: '🔵 Phase 2: UI Mastery',
      collapsed: true,
      items: [
        {
          type: 'category',
          label: '🧭 Lesson 06: Navigation & Routing',
          items: [
            'modules/lesson_06/concept',
          ],
        },
        {
          type: 'category',
          label: '🎭 Lesson 07: Theming Your App',
          items: [
            'modules/lesson_07/concept',
            'modules/lesson_07/workshop_07',
            'modules/lesson_07/workshop_07_part2',
            'modules/lesson_07/workshop_07_part3',
            'modules/lesson_07/diagram',
          ],
        },
        {
          type: 'category',
          label: '✨ Lesson 08: Animations & Transitions',
          items: [
            'modules/lesson_08/concept',
            'modules/lesson_08/workshop_08',
            'modules/lesson_08/workshop_08_part2',
            'modules/lesson_08/diagram',
          ],
        },
        {
          type: 'category',
          label: '📱 Lesson 09: Responsive UI',
          items: [
            'modules/lesson_09/concept',
            'modules/lesson_09/workshop_09',
            'modules/lesson_09/workshop_09_part2',
            'modules/lesson_09/diagram',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: '🟡 Phase 3: State Management',
      collapsed: true,
      items: [
        {
          type: 'category',
          label: '🎯 Lesson 10: setState & Stateful Widgets',
          items: [
            'modules/lesson_10/concept',
            // 'modules/lesson_10/workshop_10',
            // 'modules/lesson_10/workshop_10_part2',
            'modules/lesson_10/diagram',
          ],
        },
        {
          type: 'category',
          label: '🎯 Lesson 11: Provider Pattern',
          items: [
            'modules/lesson_11/concept',
            // 'modules/lesson_11/workshop_11',
            // 'modules/lesson_11/workshop_11_part2',
            'modules/lesson_11/diagram',
          ],
        },
        {
          type: 'category',
          label: '🎯 Lesson 12: Bloc Pattern',
          items: [
            'modules/lesson_12/concept',
            // 'modules/lesson_12/workshop_12',
            // 'modules/lesson_12/workshop_12_part2',
            'modules/lesson_12/diagram',
          ],
        },
        {
          type: 'category',
          label: '🎯 Lesson 13: Riverpod',
          items: [
            'modules/lesson_13/concept',
            // 'modules/lesson_13/workshop_13',
            // 'modules/lesson_13/workshop_13_part2',
            'modules/lesson_13/diagram',
          ],
        },
        {
          type: 'category',
          label: '🎯 Lesson 14: State Management Decision Framework',
          items: [
            'modules/lesson_14/concept',
            // 'modules/lesson_14/workshop_14',
          ],
        },
        {
          type: 'category',
          label: '🚀 Lesson 15: AuthFlow Pro - Hybrid Architecture',
          items: [
            'modules/lesson_15/concept',
            // 'modules/lesson_15/workshop_15',
            'modules/lesson_15/diagram',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: '🟠 Phase 4: Data & Storage',
      collapsed: true,
      items: [
        {
          type: 'category',
          label: '🌐 Lesson 16: Networking with Dio & Retrofit',
          items: [
            'modules/lesson_16/concept',
            'modules/lesson_16/workshop_16',
            'modules/lesson_16/diagram',
          ],
        },
        {
          type: 'category',
          label: '💾 Lesson 17: Local Storage (Hive/SQLite)',
          items: [
            'modules/lesson_17/concept',
            'modules/lesson_17/workshop_17',
            'modules/lesson_17/diagram',
          ],
        },
        {
          type: 'category',
          label: '📊 Lesson 18: NewsHub Ultimate - Data Integration',
          items: [
            'modules/lesson_18/concept',
            'modules/lesson_18/workshop_18',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: '🔴 Phase 5: Firebase & Cloud',
      collapsed: true,
      items: [
        {
          type: 'category',
          label: '🔐 Lesson 19: Firebase Auth + Firestore',
          items: [
            'modules/lesson_19/concept',
            'modules/lesson_19/workshop_19',
            'modules/lesson_19/diagram',
          ],
        },
        {
          type: 'category',
          label: '☁️ Lesson 20: Cloud Functions + Push Notifications',
          items: [
            'modules/lesson_20/concept',
            'modules/lesson_20/workshop_20',
            'modules/lesson_20/diagram',
          ],
        },
        {
          type: 'category',
          label: '🌟 Lesson 21: ConnectPro Ultimate - Social Platform',
          items: [
            'modules/lesson_21/concept',
            'modules/lesson_21/workshop_21',
            'modules/lesson_21/diagram',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: '🟣 Phase 6: Production Ready',
      collapsed: true,
      items: [
        {
          type: 'category',
          label: '🧪 Lesson 22: Unit & Widget Testing',
          items: [
            'modules/lesson_22/concept',
            'modules/lesson_22/workshop_22',
            'modules/lesson_22/diagram',
          ],
        },
        {
          type: 'category',
          label: '🔍 Lesson 23: Integration Testing + Mocking',
          items: [
            'modules/lesson_23/concept',
            'modules/lesson_23/workshop_23',
            'modules/lesson_23/diagram',
          ],
        },
        {
          type: 'category',
          label: '📈 Lesson 24: Error Handling & Logging',
          items: [
            'modules/lesson_24/concept',
            'modules/lesson_24/workshop_24',
            'modules/lesson_24/diagram',
          ],
        },
        {
          type: 'category',
          label: '🚀 Lesson 25: CI/CD with GitHub Actions',
          items: [
            'modules/lesson_25/concept',
            'modules/lesson_25/workshop_25',
            'modules/lesson_25/diagram',
          ],
        },
        {
          type: 'category',
          label: '📱 Lesson 26: App Store Deployment',
          items: [
            'modules/lesson_26/concept',
            'modules/lesson_26/workshop_26',
            'modules/lesson_26/diagram',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: '🟣 Workshop',
      collapsed: true,
      items: [
        {
          type: 'category',
          label: 'Pokedex',
          items: [
           'modules/workshop/pokedexSplash',
           'modules/workshop/pokedexLogin',
           'modules/workshop/pokedexList',
           'modules/workshop/pokedexDetail',
          ],
        },
      ],
    },
  ],
};

module.exports = sidebars;