import React, { useEffect, useState, useMemo } from 'react';
import { Outlet } from 'react-router-dom';

import { MainLayoutContext } from '@utils/context';
import { useWindowSize } from '@utils/hook';
import { breakPoint } from '@utils/constant';
import S from './MainLayout.style';

import Header from '../Header/Header';
import SideNavigation from '../SideNavigation/SideNavigation';
import SideFriendList from '../SideFriendList/SideFriendList';
import { Friends } from '@components/cores';

const { screenSize } = breakPoint;

const sideComponentInitState = { open: false, backdrop: false };

function MainLayout() {
  const { innerWidth } = useWindowSize();

  const [sideNavState, setSideNavState] = useState({ ...sideComponentInitState });
  const [sideFriendState, setSideFriendState] = useState({ ...sideComponentInitState });

  const setInitNavState = () => {
    // wide laptop 사이즈 보다 작을때 backdrop true!!
    if (innerWidth > screenSize.wideLaptop) {
      setSideNavState({ open: true, backdrop: false });
    } else {
      setSideNavState({ open: false, backdrop: true });
    }
  };

  const setInitFriendListState = () => {
    // laptop 사이즈 보다 작을때 backdrop true!!
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

  const handleToggleSideFriend = () => {
    setSideFriendState(prev => ({ ...prev, open: !prev.open }));
  };

  const mainLayoutContextValue = useMemo(
    () => ({
      sideNavState,
      sideFriendState,
      onToggleSideNav: handleToggleSideNav,
      onToggleSideFriend: handleToggleSideFriend,
    }),
    [sideNavState, sideFriendState]
  );

  return (
    <MainLayoutContext.Provider value={mainLayoutContextValue}>
      <Header />
      <SideNavigation />
      <S.MainContentContainer sideNavState={sideNavState}>
        <Outlet />
      </S.MainContentContainer>
      <SideFriendList />
      <S.FriendListToggleBtn onClick={handleToggleSideFriend} isShow={sideFriendState.open}>
        <Friends />
      </S.FriendListToggleBtn>
    </MainLayoutContext.Provider>
  );
}

export default MainLayout;
