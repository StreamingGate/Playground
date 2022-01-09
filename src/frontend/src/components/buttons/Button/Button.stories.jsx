import React from 'react';

import Typography from '@components/core/Typography/Typography';
import Button from './Button';

export default {
  title: 'Components/Buttons/Button',
  component: Button,
  decorators: [
    story => (
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-around' }}>
        {story()}
      </div>
    ),
  ],
  args: {
    children: <Typography type='content'>구독</Typography>,
  },
  parameters: { controls: { exclude: ['children'] } },
};

const SizeTemplate = args => (
  <>
    <Button size='small' {...args} />
    <Button size='large' {...args} />
  </>
);
export const Size = SizeTemplate.bind({});
Size.args = {
  variant: 'contained',
  color: 'youtubeRed',
};

const VariantTemplate = args => (
  <>
    <Button variant='contained' {...args} />
    <Button variant='outlined' {...args} />
  </>
);
export const Variant = VariantTemplate.bind({});
Variant.args = {
  size: 'small',
  color: 'youtubeRed',
};

const ColorTemplate = args => (
  <>
    <Button color='youtubeRed' {...args} />
    <Button color='youtubeBlue' {...args} />
  </>
);
export const Color = ColorTemplate.bind({});
Color.args = {
  size: 'small',
  variant: 'contained',
  children: <Typography type='content'>스트리밍 시작</Typography>,
};
