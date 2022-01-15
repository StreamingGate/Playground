import React from 'react';

import MainLayout from './MainLayout';

export default {
  title: 'Layouts/MainLayout',
  component: MainLayout,
  parameters: {
    layout: 'fullscreen',
  },
  decorators: [
    Story => (
      <div style={{ flex: '1' }}>
        <Story />
      </div>
    ),
  ],
};

const Template = args => <MainLayout {...args} />;
export const MainLayoutStory = Template.bind({});
MainLayoutStory.storyName = 'MainLayout';
