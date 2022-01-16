import React from 'react';

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
};

const Template = args => <MainLayout {...args} />;
export const MainLayoutStory = Template.bind({});
MainLayoutStory.storyName = 'MainLayout';
