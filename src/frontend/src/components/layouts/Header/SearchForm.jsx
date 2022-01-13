import React, { useContext } from 'react';

import { Search } from '@components/cores';

import { HeaderContext } from '@utils/context';
import S from './Header.style';

function SearchSection() {
  const { isShow } = useContext(HeaderContext);

  return (
    <S.SearchContainer style={{ display: isShow }}>
      <S.SearchInput />
      <S.SearchButton>
        <Search />
      </S.SearchButton>
    </S.SearchContainer>
  );
}

export default SearchSection;
