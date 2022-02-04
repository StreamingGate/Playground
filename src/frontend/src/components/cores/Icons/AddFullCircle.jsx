import React from 'react';

import AddFullCircle from '@assets/icons/AddFullCircle.svg';

import withSvgIcon from './withSvgIcon';

function CustomAddFullCircle(props) {
  return <AddFullCircle {...props} />;
}

export default withSvgIcon(CustomAddFullCircle);
