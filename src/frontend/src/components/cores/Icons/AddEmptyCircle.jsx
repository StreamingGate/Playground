import React from 'react';
import AddEmptyCircle from '@assets/icons/AddEmptyCircle.svg';

import withSvgIcon from './withSvgIcon';

function CustomAddEmptyCircle(props) {
  return <AddEmptyCircle {...props} />;
}

export default withSvgIcon(CustomAddEmptyCircle);
