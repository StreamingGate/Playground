import React from 'react';

import ChannelPage from './ChannelPage';

export default {
  title: 'Page/ChannelPage',
  component: ChannelPage,
  parameters: {
    layout: 'fullscreen',
    controls: { hideNoControlsWarning: true },
  },
};

const Template = args => <ChannelPage {...args} />;

export const ChannelPageStory = Template.bind({});
ChannelPageStory.storyName = 'ChannelPage';
