import React from 'react';

import ChatDialog from './ChatDialog';

export default {
  title: 'Components/Data Displays/ChatDialog',
  component: ChatDialog,
  args: {
    chatInfo: {
      timeStamp: '오후 2:30',
      userName: '닉네임',
      message: '이것은 채팅 입니다.',
    },
  },
};

const Template = args => {
  return <ChatDialog {...args} />;
};

export const ChatDialogStory = Template.bind({});
ChatDialogStory.args = {
  isAdmin: false,
};
ChatDialogStory.storyName = 'ChatDialog';

export const AmdinChatDialog = Template.bind({});
AmdinChatDialog.args = {
  isAdmin: true,
};
