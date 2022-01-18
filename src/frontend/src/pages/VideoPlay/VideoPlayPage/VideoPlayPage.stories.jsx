import React from 'react';

import VideoPlayPage from './VideoPlayPage';

export default {
  title: 'Page/VideoPlay',
  component: VideoPlayPage,
  parameters: {
    layout: 'fullscreen',
    controls: { hideNoControlsWarning: true },
  },
};

const Template = args => <VideoPlayPage {...args} />;

export const VideoPlayPageStory = Template.bind({});
VideoPlayPageStory.storyName = 'VideoPlay';
