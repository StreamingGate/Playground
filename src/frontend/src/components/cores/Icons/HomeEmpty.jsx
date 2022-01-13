import React from 'react';
import HomeEmpty from '@assets/icons/HomeEmpty.svg';

import withSvgIcon from './withSvgIcon';

function CustomHomeEmpty(props) {
  return <HomeEmpty {...props} />;
}

export default withSvgIcon(CustomHomeEmpty);
