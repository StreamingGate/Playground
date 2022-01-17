import React, { useContext } from 'react';

import { MainLayoutContext } from '@utils/context';
import S from './SideNavigation.style';

import { HomeEmpty, History, ThumbUp, MyVideo, HamburgerBar } from '@components/cores';
import { BackDrop } from '@components/feedbacks';
import NavigationItem from './NavigationItem';

const myNavigationItems = [
  { path: '/*', itemIcon: <History />, content: '시청한 동영상' },
  { path: '/**', itemIcon: <ThumbUp />, content: '좋아요 표시한 동영상' },
  { path: '/***', itemIcon: <MyVideo />, content: '내 동영상' },
];

function SideNavigation() {
  const { sideNavState, onToggleSideNav } = useContext(MainLayoutContext);

  return (
    <>
      <BackDrop
        isOpen={sideNavState.open && sideNavState.backdrop}
        zIndex={2}
        onClick={onToggleSideNav}
      />
      <S.SideNavigationContainer state={sideNavState}>
        {sideNavState.open && sideNavState.backdrop && (
          <S.NavigationLogoContainer>
            <S.HamburgerIconBtn onClick={onToggleSideNav}>
              <HamburgerBar />
            </S.HamburgerIconBtn>
            <S.NavigationLogo />
          </S.NavigationLogoContainer>
        )}
        <ul>
          <NavigationItem
            type='base'
            path='/'
            itemIcon={<HomeEmpty />}
            fontType='component'
            content='홈'
          />
          <S.MyNavigationItems>
            {myNavigationItems.map(({ path, itemIcon, content }) => (
              <NavigationItem
                type='base'
                key={path}
                path={path}
                itemIcon={itemIcon}
                fontType='component'
                content={content}
              />
            ))}
          </S.MyNavigationItems>
        </ul>
      </S.SideNavigationContainer>
    </>
  );
}

export default SideNavigation;
