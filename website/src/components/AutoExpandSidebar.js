import { useEffect } from 'react';
import { useLocation } from '@docusaurus/router';

// Component to auto-expand sidebar sections based on current page
export default function AutoExpandSidebar() {
  const location = useLocation();

  useEffect(() => {
    // Wait for the DOM to be ready
    const timer = setTimeout(() => {
      try {
        // Find the active menu item
        const activeItem = document.querySelector('.menu__link--active');
        
        if (activeItem) {
          // Find all parent collapsed items and expand them
          let parent = activeItem.closest('.menu__list-item');
          while (parent) {
            const collapseButton = parent.querySelector('.menu__link--sublist-caret');
            const parentListItem = parent.querySelector('.menu__list-item--collapsed');
            
            if (parentListItem && collapseButton) {
              // Expand the collapsed section
              parentListItem.classList.remove('menu__list-item--collapsed');
            }
            
            // Move up to the next parent
            parent = parent.parentElement?.closest('.menu__list-item');
          }
          
          // Ensure the active item is visible by scrolling it into view
          activeItem.scrollIntoView({
            behavior: 'smooth',
            block: 'nearest',
            inline: 'nearest'
          });
        }
        
        // Special handling for Phase 6 lessons (22-26) to ensure they're always visible
        if (location.pathname.includes('/lesson-2')) {
          const phase6Container = document.querySelector('[href*="lesson-22"], [href*="lesson-23"], [href*="lesson-24"], [href*="lesson-25"], [href*="lesson-26"]')?.closest('.menu__list-item');
          
          if (phase6Container) {
            const phase6Parent = phase6Container.parentElement?.closest('.menu__list-item');
            if (phase6Parent) {
              const collapseButton = phase6Parent.querySelector('.menu__link--sublist-caret');
              const parentListItem = phase6Parent.querySelector('.menu__list-item--collapsed');
              
              if (parentListItem && collapseButton) {
                parentListItem.classList.remove('menu__list-item--collapsed');
              }
            }
          }
        }
        
      } catch (error) {
        console.warn('AutoExpandSidebar: Error expanding sidebar sections:', error);
      }
    }, 100);

    return () => clearTimeout(timer);
  }, [location.pathname]);

  return null; // This component doesn't render anything
}
