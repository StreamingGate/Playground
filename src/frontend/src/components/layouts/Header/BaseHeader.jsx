import React, { useContext, useState } from 'react';

import * as S from './Header.style';
import { HeaderContext, MainLayoutContext } from '@utils/context';

import { IconButton } from '@components/buttons';
import { HamburgerBar, AddEmptyCircle, Alarm, Search, AddFullCircle } from '@components/cores';
import SearchForm from './SearchForm';

function BaseHeader() {
  const { onToggle } = useContext(HeaderContext);
  const { onToggleSideNav } = useContext(MainLayoutContext);

  const [isAddButtonToggle, setAddButtonToggle] = useState(false);

  const handleAddButtonToggle = () => {
    setAddButtonToggle(prev => !prev);
  };

  return (
    <>
      <S.HeaderLeftDiv>
        <S.HambergurIconButton onClick={onToggleSideNav}>
          <HamburgerBar />
        </S.HambergurIconButton>
        <S.VerticalLogoIcon />
      </S.HeaderLeftDiv>
      <SearchForm />
      <S.HeaderRightDiv>
        <S.SearchBarIconButton onClick={onToggle}>
          <Search />
        </S.SearchBarIconButton>
        <div>
          <IconButton onClick={handleAddButtonToggle}>
            {isAddButtonToggle ? <AddFullCircle /> : <AddEmptyCircle />}
          </IconButton>
          <S.AddVideoMenuContainer></S.AddVideoMenuContainer>
        </div>
        <div>
          <IconButton>
            <Alarm />
          </IconButton>
        </div>
        <div>
          <S.HeaderAvatar />
        </div>
      </S.HeaderRightDiv>
    </>
  );
}

export default BaseHeader;
