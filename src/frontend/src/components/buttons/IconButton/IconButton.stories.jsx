import React from 'react';

import { AddEmptyCircle } from '@components/cores';
import IconButton from './IconButton';

export default {
  title: 'Components/Buttons/IconButton',
  component: IconButton,
  parameters: { controls: { exclude: ['children', 'className'] } },
};

const SizeTemplate = args => (
  <>
    <IconButton size='small' {...args}>
      <AddEmptyCircle size='small' />
    </IconButton>
    <IconButton size='large' {...args}>
      <AddEmptyCircle size='large' />
    </IconButton>
  </>
);

export const Size = SizeTemplate.bind({});
