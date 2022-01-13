import React from 'react';

import { HomeEmpty, History, ThumbUp, MyVideo } from '@components/cores';
import NavigationItem from './NavigationItem';

const miniNavigationItems = [
  { path: '/', itemIcon: <HomeEmpty />, content: '홈' },
  { path: '/*', itemIcon: <History />, content: '시청' },
  { path: '/**', itemIcon: <ThumbUp />, content: '좋아요' },
  { path: '/***', itemIcon: <MyVideo />, content: '내 동영상' },
];

function MiniSideNavigation() {
  return (
    <ul>
      {miniNavigationItems.map(({ path, itemIcon, content }) => (
        <NavigationItem
          key={path}
          path={path}
          itemIcon={itemIcon}
          fontType='bottomTab'
          content={content}
        />
      ))}
    </ul>
  );
}

export default MiniSideNavigation;
