import React from 'react';

import Avatar from './Avatar';

export default {
  title: 'Components/Data DisPlays/Avatar',
  component: Avatar,
  parameters: {
    controls: { exclude: ['className', 'imgSrc'] },
  },
};

const SizeTemplate = args => (
  <>
    <Avatar size='small' {...args} />
    <Avatar size='medium' {...args} />
    <Avatar size='large' {...args} />
  </>
);

export const Size = SizeTemplate.bind({});
