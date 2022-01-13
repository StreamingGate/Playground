import React, { useEffect, useState, useMemo } from 'react';

import { HeaderContext } from '@utils/context';
import { breakPoint } from '@utils/constant';
import S from './Header.style';

import BaseHeader from './BaseHeader';
import ResponsiveSearchBar from './ResponsiveSearchBar';

const { screenSize } = breakPoint;

function Header() {
  const [windowSize, setWindowSize] = useState(window.innerWidth);
  const [showResponsiveSearchBar, setShowResponsiveSearchBar] = useState(false);

  const handleWindowResize = () => {
    const currentSize = window.innerWidth;

    if (currentSize > screenSize.tablet) {
      setShowResponsiveSearchBar(false);
    }
    setWindowSize(window.innerWidth);
  };

  const handleResponsiveSearchBarToggle = () => {
    setShowResponsiveSearchBar(prevState => !prevState);
  };

  useEffect(() => {
    window.addEventListener('resize', handleWindowResize);
    return () => window.removeEventListener('resize', handleWindowResize);
  });

  const headerContextValue = useMemo(
    () => ({
      isShow: windowSize <= screenSize.tablet && showResponsiveSearchBar && 'flex',
      onToggle: handleResponsiveSearchBarToggle,
    }),
    [showResponsiveSearchBar, windowSize]
  );

  return (
    <HeaderContext.Provider value={headerContextValue}>
      <S.Header>{showResponsiveSearchBar ? <ResponsiveSearchBar /> : <BaseHeader />}</S.Header>
    </HeaderContext.Provider>
  );
}

export default Header;
