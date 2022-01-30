import React from 'react';

import ChipButton from './ChipButton';

export default {
  title: 'Components/Buttons/ChipButton',
  component: ChipButton,
  args: {
    content: 'K-POP',
  },
};

const Template = args => <ChipButton {...args} />;

export const ChipButtonTemplate = Template.bind({});
ChipButtonTemplate.storyName = 'ChipButton';
