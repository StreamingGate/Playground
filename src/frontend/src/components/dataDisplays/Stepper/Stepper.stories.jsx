import React from 'react';

import { theme } from '@utils/constant';

import Stepper from './Stepper';

export default {
  title: 'Components/Data Displays/Stepper',
  component: Stepper,
  argTypes: {
    inActiveColor: { control: { type: 'color' } },
    activeColor: { control: { type: 'color' } },
  },
  args: {
    step: 3,
    activeStep: 1,
    inActiveColor: theme.colors.pgMint,
    activeColor: theme.colors.pgBlue,
    width: '20px',
    spacing: '5px',
  },
};

const Template = args => <Stepper {...args} />;

export const StepperStory = Template.bind({});
StepperStory.storyName = 'Stepper';
