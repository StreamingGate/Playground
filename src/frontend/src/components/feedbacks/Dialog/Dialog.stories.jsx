import React from 'react';

import Dialog from './Dialog';

export default {
  title: 'Components/Feedbacks/Dialog',
  component: Dialog,
  parameters: { layout: 'fullscreen' },
};

const Template = args => <Dialog {...args} />;

export const DialogStory = Template.bind({});
DialogStory.storyName = 'Dialog';
