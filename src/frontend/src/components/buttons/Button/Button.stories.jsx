import React from 'react';

import { Typography } from '@components/cores';
import { NormalWrapper } from '@components/storybook';
import Button from './Button';

export default {
  title: 'Components/Buttons/Button',
  component: Button,
  args: {
    fullWidth: false,
    children: <Typography type='content'>구독</Typography>,
  },
  parameters: { controls: { exclude: ['children', 'className'] } },
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
    <Button size='sm' {...args} />
    <Button size='md' {...args} />
    <Button size='lg' {...args} />
  </>
);
export const Size = SizeTemplate.bind({});
Size.args = {
  variant: 'contained',
  color: 'pgOrange',
};

const VariantTemplate = args => (
  <>
    <Button variant='contained' {...args} />
    <Button variant='outlined' {...args} />
    <Button variant='text' {...args} />
  </>
);
export const Variant = VariantTemplate.bind({});
Variant.args = {
  size: 'small',
  color: 'pgOrange',
};

const ColorTemplate = args => (
  <>
    <Button color='pgOrange' {...args} />
    <Button color='pgBlue' {...args} />
  </>
);
export const Color = ColorTemplate.bind({});
Color.args = {
  size: 'small',
  variant: 'contained',
  children: <Typography type='content'>스트리밍 시작</Typography>,
};
