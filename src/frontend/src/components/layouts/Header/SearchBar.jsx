import React, { useContext } from 'react';

import { HeaderContext } from '@utils/context';
import * as S from './Header.style';

import { IconButton } from '@components/buttons';
import { ArrowBack } from '@components/cores';
import SearchForm from './SearchForm';

function SearchBar() {
  const { onToggle } = useContext(HeaderContext);

  return (
    <>
      <IconButton onClick={onToggle}>
        <ArrowBack />
      </IconButton>
      <SearchForm />
      <S.SearchBarAvatar />
    </>
  );
}

export default SearchBar;
