import React from 'react';

import SideFriendList from './SideFriendList';

export default {
  title: 'Components/layouts/SideFriendList',
  component: SideFriendList,
  parameters: {
    layout: 'fullscreen',
  },
  decorators: [
    Story => (
      <div style={{ flex: 1 }}>
        <div style={{ height: '60px' }} />
        <Story />
      </div>
    ),
  ],
  args: {
    friends: [
      { isOnline: false, profileImgSrc: '', name: '김하늬' },
      { isOnline: false, profileImgSrc: '', name: '서채희' },
      { isOnline: false, profileImgSrc: '', name: '이우재' },
      { isOnline: false, profileImgSrc: '', name: 'Daniel Radcliffe' },
      { isOnline: false, profileImgSrc: '', name: 'Emma Watson' },
      { isOnline: false, profileImgSrc: '', name: 'Tom Holland' },
      { isOnline: false, profileImgSrc: '', name: 'Rupert Grint' },
      { isOnline: false, profileImgSrc: '', name: '황예지' },
      { isOnline: false, profileImgSrc: '', name: '강슬기' },
      { isOnline: false, profileImgSrc: '', name: '차정원' },
      { isOnline: false, profileImgSrc: '', name: '신류진' },
      { isOnline: false, profileImgSrc: '', name: '이이경' },
    ],
  },
};

const Template = args => <SideFriendList {...args} />;
export const SideFriendListStory = Template.bind({});
SideFriendListStory.storyName = 'SideFriendList';
