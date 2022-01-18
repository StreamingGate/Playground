import React from 'react';
import { MemoryRouter, Routes, Route } from 'react-router-dom';

import MyPage from './MyPage';

export default {
  title: 'Page/MyPage',
  component: MyPage,
  parameters: {
    layout: 'fullscreen',
    controls: { hideNoControlsWarning: true },
  },
};

const Template = args => {
  const { path } = args;
  return (
    <MemoryRouter initialEntries={path}>
      <Routes>
        <Route path='/mypage/:type' element={<MyPage {...args} />} />
      </Routes>
    </MemoryRouter>
  );
};

export const History = Template.bind({});
History.args = { path: ['/mypage/history'] };

export const Like = Template.bind({});
Like.args = { path: ['/mypage/like'] };

export const Library = Template.bind({});
Library.args = { path: ['/mypage/library'] };
