import React from 'react';

import Avatar from './Avatar';
import { NormalWrapper } from '@components/storybook';

export default {
  title: 'Components/Data DisPlays/Avatar',
  component: Avatar,
  parameters: {
    controls: { exclude: ['className', 'imgSrc'] },
  },
  decorators: [
    Story => (
      <NormalWrapper>
        <Story />
      </NormalWrapper>
    ),
  ],
};

const SizeTemplate = args => (
  <>
    <Avatar size='small' {...args} />
    <Avatar size='medium' {...args} />
    <Avatar size='large' {...args} />
    <Avatar size='exLarge' {...args} />
  </>
);

export const Size = SizeTemplate.bind({});
