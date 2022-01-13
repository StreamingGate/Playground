import React, { useState, useMemo } from 'react';

import { HeaderContext } from '@utils/context';
import { breakPoint } from '@utils/constant';
import { useWindowSize } from '@util/hook';
import S from './Header.style';

import BaseHeader from './BaseHeader';
import SearchBar from './SearchBar';

const { screenSize } = breakPoint;

function Header() {
  const { innerWidth } = useWindowSize();
  const [showSearchBar, setShoweSearchBar] = useState(false);

  const handleResponsiveSearchBarToggle = () => {
    setShoweSearchBar(prevState => !prevState);
  };

  const headerContextValue = useMemo(
    () => ({
      isShow: innerWidth <= screenSize.tablet && showSearchBar && 'flex',
      onToggle: handleResponsiveSearchBarToggle,
    }),
    [showSearchBar, innerWidth]
  );

  return (
    <HeaderContext.Provider value={headerContextValue}>
      <S.Header>{showSearchBar ? <SearchBar /> : <BaseHeader />}</S.Header>
    </HeaderContext.Provider>
  );
}

export default Header;
