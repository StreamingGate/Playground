import React from 'react';
import HamburgerBar from '@assets/icons/HamburgerBar.svg';

import withSvgIcon from './withSvgIcon';

function CustomHamburgerBar(props) {
  return <HamburgerBar {...props} />;
}

export default withSvgIcon(CustomHamburgerBar);
