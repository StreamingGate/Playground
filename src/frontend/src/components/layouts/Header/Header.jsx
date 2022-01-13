import React, { useEffect, useState, useMemo } from 'react';

import { HeaderContext } from '@utils/context';
import { breakPoint } from '@utils/constant';
import S from './Header.style';

import BaseHeader from './BaseHeader';
import SearchBar from './SearchBar';

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
      <S.Header>{showResponsiveSearchBar ? <SearchBar /> : <BaseHeader />}</S.Header>
    </HeaderContext.Provider>
  );
}

export default Header;
