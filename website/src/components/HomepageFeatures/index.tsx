import type {ReactNode} from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<'svg'>>;
  description: ReactNode;
};

const FeatureList: FeatureItem[] = [
  {
    title: '🚀 Hands-On Learning',
    Svg: require('@site/static/img/undraw_docusaurus_mountain.svg').default,
    description: (
      <>
        Learn Flutter through practical projects. Every lesson includes working code, 
        real applications, and hands-on workshops. No passive learning - build apps from day one.
      </>
    ),
  },
  {
    title: '📱 Production Ready',
    Svg: require('@site/static/img/undraw_docusaurus_tree.svg').default,
    description: (
      <>
        Master modern Flutter patterns, state management, testing, and deployment. 
        Build apps that can ship to the App Store and Google Play with confidence.
      </>
    ),
  },
  {
    title: '⚡ Complete Curriculum',
    Svg: require('@site/static/img/undraw_docusaurus_react.svg').default,
    description: (
      <>
        26 comprehensive lessons covering everything from Dart basics to production deployment.
        Firebase, testing, CI/CD, and professional development workflows included.
      </>
    ),
  },
];

function Feature({title, Svg, description}: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
