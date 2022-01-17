import React from 'react';

import VideoPlayPage from './VideoPlayPage';

export default {
  title: 'Page/VideoPlay',
  component: VideoPlayPage,
};

const Template = args => <VideoPlayPage {...args} />;

export const VideoPlayPageStory = Template.bind({});
VideoPlayPageStory.storyName = 'VideoPlay';
