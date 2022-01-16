import React from 'react';
import Search from '@assets/icons/Search.svg';

import withSvgIcon from './withSvgIcon';

function CustomSearch(props) {
  return <Search {...props} />;
}

export default withSvgIcon(CustomSearch);
