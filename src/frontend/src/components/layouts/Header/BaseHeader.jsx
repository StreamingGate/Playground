import React, { useContext } from 'react';

import { IconButton } from '@components/buttons';
import { HamburgerBar, AddEmptyCircle, Alarm, Search } from '@components/cores';
import SearchSection from './SearchSection';
import Profile from './Profile';

import { HeaderContext } from '@/utils/context';
import S from './Header.style';

function BaseHeader() {
  const { onToggle } = useContext(HeaderContext);

  return (
    <>
      <S.HeaderLeftDiv>
        <IconButton>
          <HamburgerBar />
        </IconButton>
        <S.VerticalLogo />
      </S.HeaderLeftDiv>
      <SearchSection />
      <S.HeaderRightDiv>
        <S.TabletSearchIconButton onClick={onToggle}>
          <Search />
        </S.TabletSearchIconButton>
        <IconButton>
          <AddEmptyCircle />
        </IconButton>
        <IconButton>
          <Alarm />
        </IconButton>
        <Profile />
      </S.HeaderRightDiv>
    </>
  );
}

export default BaseHeader;
