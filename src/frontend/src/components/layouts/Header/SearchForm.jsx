import React, { useContext } from 'react';

import { Search } from '@components/cores';

import { HeaderContext } from '@utils/context';
import * as S from './Header.style';

function SearchSection() {
  const { isShow } = useContext(HeaderContext);

  return (
    <S.SearchContainer style={{ display: isShow }}>
      <S.SearchInput placeholder='검색' />
      <S.SearchButton>
        <Search />
      </S.SearchButton>
    </S.SearchContainer>
  );
}

export default SearchSection;
