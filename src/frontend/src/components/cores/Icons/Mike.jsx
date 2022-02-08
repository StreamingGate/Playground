import React from 'react';

import Mike from '@assets/icons/Mike.svg';

import withSvgIcon from './withSvgIcon';

function CustomMike(props) {
  return <Mike {...props} />;
}

export default withSvgIcon(CustomMike);
