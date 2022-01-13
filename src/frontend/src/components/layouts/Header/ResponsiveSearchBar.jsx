import React, { useContext } from 'react';

import { HeaderContext } from '@utils/context';

import { IconButton } from '@components/buttons';
import { ArrowBack } from '@components/cores';
import Profile from './Profile';
import SearchSection from './SearchSection';

function ResponsiveSearchBar() {
  const { onToggle } = useContext(HeaderContext);

  return (
    <>
      <IconButton onClick={onToggle}>
        <ArrowBack />
      </IconButton>
      <SearchSection />
      <Profile />
    </>
  );
}

export default ResponsiveSearchBar;
