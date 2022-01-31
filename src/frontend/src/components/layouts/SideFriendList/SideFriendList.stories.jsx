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
  },
};

const Template = args => <SideFriendList {...args} />;
export const SideFriendListStory = Template.bind({});
SideFriendListStory.storyName = 'SideFriendList';
