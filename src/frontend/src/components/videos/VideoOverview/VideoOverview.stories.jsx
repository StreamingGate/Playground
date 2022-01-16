import React from 'react';

import ThumbNailDummy from '@assets/image/ThumbNailDummy.jpg';

import VideoOverview from './VideoOverview';

export default {
  title: 'Components/Videos/VideoOverview',
  component: VideoOverview,
  args: {
    thumbNailSrc: ThumbNailDummy,
    title:
      'ASMR Harry Potter●O.W.L.Exam Period of Hogwarts The Great Hall 3D Ambient Sounds | Study Aid',
    userName: 'Warner Bros',
    viewCount: 1000,
    createdAt: '13시간 전',
    isRealTime: true,
  },
};

const DirectionTemplate = args => <VideoOverview {...args} />;

export const Direction = DirectionTemplate.bind({});
