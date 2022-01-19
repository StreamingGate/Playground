import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom';

import { MainLayoutContext } from '@utils/context';

import SideNavigation from './SideNavigation';

export default {
  title: 'Components/Layouts/SideNavigation',
  component: SideNavigation,
  decorators: [
    (Story, rest) => {
      const { args } = rest;
      return (
        <Router>
          <MainLayoutContext.Provider value={{ ...args.ctx }}>
            <div style={{ height: '60px' }} />
            <Story />
          </MainLayoutContext.Provider>
        </Router>
      );
    },
  ],
  parameters: {
    layout: 'fullscreen',
    controls: { hideNoControlsWarning: true, exclude: ['ctx'] },
    previewTabs: {
      'storybook/docs/panel': { hidden: true },
    },
  },
  args: {
    ctx: { sideNavState: { open: true, backdrop: false }, onToggleSideNav: undefined },
  },
};

const Template = args => <SideNavigation {...args} />;

export const SideNavigationStory = Template.bind({});
SideNavigationStory.storyName = 'SideNavigation';
