import React from 'react';

import { MainLayoutContext } from '@utils/context';

import Header from './Header';

export default {
  title: 'Layouts/Header',
  component: Header,
  decorators: [
    (Story, rest) => {
      const { args } = rest;
      return (
        <MainLayoutContext.Provider value={{ ...args.ctx }}>
          <div style={{ flex: '1' }}>
            <Story />
          </div>
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
};

const Template = args => <Header {...args} />;

export const HeaderStory = Template.bind({});
HeaderStory.args = {
  ctx: { onToggleSideNav: undefined },
};
HeaderStory.storyName = 'Header';
