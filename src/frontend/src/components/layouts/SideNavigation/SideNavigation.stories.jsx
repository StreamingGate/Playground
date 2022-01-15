import React, { useContext } from 'react';

import { MainLayoutContext } from '@utils/constant';

import SideNavigation from './SideNavigation';

export default {
  title: 'Layouts/SideNavigation',
  component: SideNavigation,
  parameters: {
    layout: 'fullscreen',
  },
  decorators: [
    Story => (
      <div style={{ flex: '1' }}>
        <div style={{ height: '60px' }} />

        <Story />
      </div>
    ),
  ],
};

const Template = args => <SideNavigation {...args} />;
export const SideNavigationStory = Template.bind({});
SideNavigationStory.storyName = 'SideNavigation';
