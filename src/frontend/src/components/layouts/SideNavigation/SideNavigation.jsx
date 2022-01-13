import React, { useEffect } from 'react';

import { useWindowSize } from '@utils/hook';

import BaseSideNavigation from './BaseSideNavigation';
import MiniSideNavigation from './MiniSideNavigation';
import S from './SideNavigation.style';

function SideNavigation() {
  const { innerWidth } = useWindowSize();

  useEffect(() => {}, [innerWidth]);

  return (
    <S.SideNavigationContainer>
      {innerWidth > 1000 ? <BaseSideNavigation /> : <MiniSideNavigation />}
    </S.SideNavigationContainer>
  );
}

export default SideNavigation;
