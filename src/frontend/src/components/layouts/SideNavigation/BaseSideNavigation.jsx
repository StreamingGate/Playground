import React from 'react';

import { HomeEmpty, History, ThumbUp, MyVideo } from '@components/cores';
import NavigationItem from './NavigationItem';

import S from './SideNavigation.style';

const myNavigationItems = [
  { path: '/*', itemIcon: <History />, content: '시청한 동영상' },
  { path: '/**', itemIcon: <ThumbUp />, content: '좋아요 표시한 동영상' },
  { path: '/***', itemIcon: <MyVideo />, content: '내 동영상' },
];

function BaseSideNavigation() {
  return (
    <ul>
      <NavigationItem path='/' itemIcon={<HomeEmpty />} fontType='component' content='홈' />
      <S.MyNavigationItems>
        {myNavigationItems.map(({ path, itemIcon, content }) => (
          <NavigationItem
            key={path}
            path={path}
            itemIcon={itemIcon}
            fontType='component'
            content={content}
          />
        ))}
      </S.MyNavigationItems>
    </ul>
  );
}

export default BaseSideNavigation;
