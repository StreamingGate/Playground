import React, { useEffect, useState, useMemo } from 'react';
import PropTypes from 'prop-types';
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
const modalInitState = { addVideo: false, profile: false, alarm: false, friend: false };

function MainLayout({ children }) {
  const { innerWidth } = useWindowSize();

  const [sideNavState, setSideNavState] = useState({ ...sideComponentInitState });
  const [sideFriendState, setSideFriendState] = useState({ ...sideComponentInitState });
  const [modalState, setModalState] = useState({ ...modalInitState });

  const handleModalClose = () => {
    setModalState({ ...modalInitState });
  };

  useEffect(() => {
    if (modalState.addVideo || modalState.profile || modalState.friend || modalState.alarm) {
      window.addEventListener('click', handleModalClose);
    }
    return () => {
      window.removeEventListener('click', handleModalClose);
    };
  }, [modalState]);

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

  const handleModalToggle = e => {
    const { currentTarget } = e;
    e.stopPropagation();
    const { name } = currentTarget.dataset;

    if (modalState[name]) {
      setModalState(prev => ({ ...prev, [name]: false }));
    } else {
      const newModalState = { ...modalInitState };
      setModalState({ ...newModalState, [name]: true });
    }
  };

  /**
   * 메인 레이아웃 컴포넌트 제어 Context API value
   */
  const mainLayoutContextValue = useMemo(
    () => ({
      sideNavState,
      sideFriendState,
      modalState,
      onToggleSideNav: handleToggleSideNav,
      onToggleSideFriend: handleToggleSideFriend,
      onToggleModal: handleModalToggle,
    }),
    [sideNavState, sideFriendState, modalState]
  );

  return (
    <MainLayoutContext.Provider value={mainLayoutContextValue}>
      <Header />
      <SideNavigation />
      <S.MainContentContainer sideNavState={sideNavState}>
        <Outlet />
        {children !== undefined && children}
      </S.MainContentContainer>
      <SideFriendList />
      <S.FriendListToggleBtn onClick={handleToggleSideFriend} isShow={sideFriendState.open}>
        <Friends />
      </S.FriendListToggleBtn>
    </MainLayoutContext.Provider>
  );
}

MainLayout.propTypes = {
  children: PropTypes.element,
};

MainLayout.defaultProps = {
  children: undefined,
};

export default MainLayout;
