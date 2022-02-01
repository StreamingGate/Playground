import React from 'react';

import { MainLayoutContext } from '@utils/context';

import Header from './Header';

export default {
  title: 'Components/Layouts/Header',
  component: Header,
  decorators: [
    (Story, rest) => {
      const { args } = rest;
      return (
        <MainLayoutContext.Provider value={{ ...args.ctx }}>
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
    ctx: {
      onToggleSideNav: undefined,
      onToggleModal: undefined,
      modalState: { addVideo: false, profile: false, friend: false },
    },
  },
};

const Template = args => <Header {...args} />;

export const HeaderStory = Template.bind({});
HeaderStory.storyName = 'Header';
