import React from 'react';

import Header from './Header';

export default {
  title: 'Layouts/Header',
  component: Header,
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

const Template = args => <Header {...args} />;
export const HeaderStory = Template.bind({});
HeaderStory.storyName = 'Header';
