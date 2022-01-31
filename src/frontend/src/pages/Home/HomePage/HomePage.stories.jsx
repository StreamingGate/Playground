import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom';

import { MainLayoutContext } from '@utils/context';

import { MainLayout } from '@components/layouts';
import HomePage from './HomePage';

export default {
  title: 'Page/Home',
  component: HomePage,
  decorators: [
    (Story, rest) => {
      const { args } = rest;
      return (
        <Router>
          <MainLayoutContext.Provider value={{ ...args.ctx }}>
            <MainLayout>
              <Story />
            </MainLayout>
          </MainLayoutContext.Provider>
        </Router>
      );
    },
  ],
  parameters: {
    layout: 'fullscreen',
    controls: { hideNoControlsWarning: true, exclude: ['ctx'] },
  },
  args: {
    ctx: { sideNavState: { open: true, backdrop: false } },
  },
};

const Template = args => <HomePage {...args} />;

export const HomePageStory = Template.bind({});
HomePageStory.storyName = 'Home';
