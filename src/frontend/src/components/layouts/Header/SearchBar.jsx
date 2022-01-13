import React, { useContext } from 'react';

import { HeaderContext } from '@utils/context';

import { IconButton } from '@components/buttons';
import { ArrowBack } from '@components/cores';
import Profile from './Profile';
import SearchForm from './SearchForm';

function SearchBar() {
  const { onToggle } = useContext(HeaderContext);

  return (
    <>
      <IconButton onClick={onToggle}>
        <ArrowBack />
      </IconButton>
      <SearchForm />
      <Profile />
    </>
  );
}

export default SearchBar;
