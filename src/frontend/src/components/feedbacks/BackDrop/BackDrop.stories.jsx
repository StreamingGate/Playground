import React from 'react';

import BackDrop from './BackDrop';

export default {
  title: 'Components/Feedbacks/BackDrop',
  component: BackDrop,
  decorators: [
    Story => (
      <div>
        <Story />
      </div>
    ),
  ],
  parameters: { layout: 'fullscreen' },
};

const Template = args => <BackDrop {...args} />;

export const BackDropStory = Template.bind({});
BackDropStory.args = {
  isOpen: true,
};
BackDropStory.storyName = 'BackDrop';
