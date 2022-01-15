import React, { useEffect, useState, useMemo } from 'react';

import { MainLayoutContext } from '@utils/context';
import { useWindowSize } from '@utils/hook';
import { breakPoint } from '@utils/constant';

import { Header, SideNavigation } from '../index';

function setInitNavState(innerWidth) {
  const { screenSize } = breakPoint;
  return innerWidth > screenSize.wideLaptop;
}

function MainLayout() {
  const { innerWidth } = useWindowSize();
  const [isSideNavOpen, setSideNavOpen] = useState(true);

  useEffect(() => {
    const isOpen = setInitNavState(innerWidth);
    if (isOpen) {
      setSideNavOpen(true);
    } else {
      setSideNavOpen(false);
    }
  }, [innerWidth]);

  const handleToggleSideNav = () => {
    setSideNavOpen(prev => !prev);
  };

  const mainLayoutContextValue = useMemo(
    () => ({ isSideNavOpen, onToggleSideNav: handleToggleSideNav }),
    [isSideNavOpen]
  );

  return (
    <MainLayoutContext.Provider value={mainLayoutContextValue}>
      <Header />
      <SideNavigation />
    </MainLayoutContext.Provider>
  );
}

export default MainLayout;
