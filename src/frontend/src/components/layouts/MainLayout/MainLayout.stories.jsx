import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom';

import MainLayout from './MainLayout';

export default {
  title: 'Components/Layouts/MainLayout',
  component: MainLayout,
  parameters: {
    layout: 'fullscreen',
    previewTabs: {
      'storybook/docs/panel': { hidden: true },
    },
    controls: { hideNoControlsWarning: true },
  },
  decorators: [
    Story => (
      <Router>
        <Story />
      </Router>
    ),
  ],
};

const Template = args => <MainLayout {...args} />;
export const MainLayoutStory = Template.bind({});
MainLayoutStory.storyName = 'MainLayout';
