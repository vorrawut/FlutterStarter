// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const {themes} = require('prism-react-renderer');
const lightCodeTheme = themes.github;
const darkCodeTheme = themes.dracula;

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Flutter Starter Curriculum',
  tagline: 'Transform from Flutter beginner to production expert',
  favicon: 'img/favicon.ico',

  // Set the production url of your site here
  url: 'https://vorrawutjudasri.github.io',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/FlutterStarter/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'vorrawutjudasri', // Usually your GitHub org/user name.
  projectName: 'FlutterStarter', // Usually your repo name.

  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          id: 'curriculum',
          sidebarPath: require.resolve('./sidebars.js'),
          path: '../class',
          routeBasePath: '/curriculum',
          editUrl: 'https://github.com/vorrawutjudasri/FlutterStarter/tree/main/class/',
          exclude: ['**/answer/**'],
        },
        blog: false,
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],
  
  plugins: [],

  themes: ['@docusaurus/theme-mermaid'],
  markdown: {
    mermaid: true,
  },

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      // Replace with your project's social card
      image: 'img/flutter-social-card.jpg',
      navbar: {
        title: 'Flutter Mastery',
        logo: {
          alt: 'Flutter Logo',
          src: 'img/logo.svg',
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'tutorialSidebar',
            position: 'left',
            label: 'Curriculum',
            docsPluginId: 'curriculum',
          },
          {
            to: '/answers',
            label: 'Answer Code',
            position: 'left',
            docsPluginId: 'answers',
          },
          {
            href: 'https://github.com/vorrawutjudasri/FlutterStarter',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Learning Path',
            items: [
              {
                label: 'Phase 1: Foundations',
                to: '/curriculum/modules/lesson_01/concept',
              },
              {
                label: 'Phase 2: UI Mastery',
                to: '/curriculum/modules/lesson_06/concept',
              },
              {
                label: 'Phase 3: State Management',
                to: '/curriculum/modules/lesson_10/concept',
              },
              {
                label: 'Phase 4: Data & Storage',
                to: '/curriculum/modules/lesson_16/concept',
              },
              {
                label: 'Phase 5: Firebase & Cloud',
                to: '/curriculum/modules/lesson_19/concept',
              },
              {
                label: 'Phase 6: Production Ready',
                to: '/curriculum/modules/lesson_22/concept',
              },
            ],
          },
          {
            title: 'Resources',
            items: [
              {
                label: 'Course Overview',
                to: '/curriculum/COURSE_OVERVIEW',
              },
              {
                label: 'Instructor Guide',
                to: '/curriculum/INSTRUCTOR_GUIDE',
              },
              {
                label: 'Project Summary',
                to: '/curriculum/PROJECT_SUMMARY',
              },
            ],
          },
          {
            title: 'More',
            items: [
              {
                label: 'GitHub',
                href: 'https://github.com/vorrawutjudasri/FlutterStarter',
              },
              {
                label: 'Demo System',
                href: 'https://github.com/vorrawutjudasri/FlutterStarter/tree/main/class/demo',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Flutter Starter Curriculum. Built with Docusaurus.`,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
        additionalLanguages: ['dart', 'bash', 'yaml', 'json'],
      },
      mermaid: {
        theme: {light: 'neutral', dark: 'dark'},
      },
    }),
};

module.exports = config;
