import React from 'react';

import { MainLayoutContext } from '@utils/context';

import SideFriendList from './SideFriendList';

export default {
  title: 'Components/Layouts/SideFriendList',
  component: SideFriendList,
  decorators: [
    (Story, rest) => {
      const { args } = rest;
      return (
        <MainLayoutContext.Provider value={args.ctx}>
          <div style={{ height: '60px' }} />
          <Story />
        </MainLayoutContext.Provider>
      );
    },
  ],
  parameters: {
    layout: 'fullscreen',
    controls: { hideNoControlsWarning: true, exclude: ['ctx'] },
    previewTabs: {
      'storybook/docs/panel': { hidden: true },
    },
  },
  args: {
    ctx: { sideFriendState: { open: true, backdrop: false }, onToggleSideFriend: undefined },
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
