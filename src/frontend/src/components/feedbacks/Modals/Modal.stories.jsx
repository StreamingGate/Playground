import React from 'react';

import AdviseModal from './AdviseModal';

export default {
  title: 'Components/FeedBacks/Modals',
  component: AdviseModal,
};

const AdviseModalTemplate = args => <AdviseModal {...args} />;
export const AdviseModalStory = AdviseModalTemplate.bind({});
AdviseModalStory.storyName = 'AdviseModal';
