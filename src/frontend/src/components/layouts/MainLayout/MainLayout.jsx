import React, { useEffect, useState, useMemo } from 'react';

import { MainLayoutContext } from '@utils/context';
import { useWindowSize } from '@utils/hook';
import { breakPoint } from '@utils/constant';
import S from './MainLayout.style';

import Header from '../Header/Header';
import SideNavigation from '../SideNavigation/SideNavigation';
import SideFriendList from '../SideFriendList/SideFriendList';

const { screenSize } = breakPoint;

function MainLayout() {
  const { innerWidth } = useWindowSize();
  const [sideNavState, setSideNavState] = useState({ open: false, backdrop: false });
  const [sideFriendState, setSideFriendState] = useState({ open: false, backdrop: false });

  const setInitNavState = () => {
    // 비디오 재생 화면, wide laptop 사이즈 보다 작을때 backdrop true!!
    if (innerWidth > screenSize.wideLaptop) {
      setSideNavState({ open: true, backdrop: false });
    } else {
      setSideNavState({ open: false, backdrop: true });
    }
  };

  const setInitFriendListState = () => {
    // 비디오 재생 화면, laptop 사이즈 보다 작을때 backdrop true!!
    if (innerWidth > screenSize.laptop) {
      setSideFriendState({ open: true, backdrop: false });
    } else {
      setSideFriendState({ open: false, backdrop: true });
    }
  };

  useEffect(() => {
    setInitNavState();
    setInitFriendListState();
  }, [innerWidth]);

  const handleToggleSideNav = () => {
    setSideNavState(prev => ({ ...prev, open: !prev.open }));
  };

  const mainLayoutContextValue = useMemo(
    () => ({ sideNavState, sideFriendState, onToggleSideNav: handleToggleSideNav }),
    [sideNavState]
  );

  return (
    <MainLayoutContext.Provider value={mainLayoutContextValue}>
      <Header />
      <S.Temp>
        <SideNavigation />
        <S.MainContentContainer>Content</S.MainContentContainer>
        <SideFriendList />
      </S.Temp>
    </MainLayoutContext.Provider>
  );
}

export default MainLayout;
