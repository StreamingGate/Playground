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
      console.log(args);
      return (
        <Router>
          <MainLayoutContext.Provider value={{ sideNavState: { open: true, backdrop: false } }}>
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
    controls: { hideNoControlsWarning: true },
  },
  args: {
    ctx: { sideNavState: { open: true, backdrop: false } },
  },
};

const Template = args => <HomePage {...args} />;

export const HomePageStory = Template.bind({});
HomePageStory.storyName = 'Home';
