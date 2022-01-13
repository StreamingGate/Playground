import React, { useContext } from 'react';

import { IconButton } from '@components/buttons';
import { HamburgerBar, AddEmptyCircle, Alarm, Search } from '@components/cores';
import SearchForm from './SearchForm';
import Profile from './Profile';

import { HeaderContext } from '@/utils/context';
import S from './Header.style';

function BaseHeader() {
  const { onToggle } = useContext(HeaderContext);

  return (
    <>
      <S.HeaderLeftDiv>
        <S.HambergurIconButton>
          <HamburgerBar />
        </S.HambergurIconButton>
        <S.VerticalLogo />
      </S.HeaderLeftDiv>
      <SearchForm />
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
