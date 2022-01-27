import React from 'react';
import ScrollDown from '@assets/icons/ScrollDown';

import withSvgIcon from './withSvgIcon';

function CustomScrollDown(props) {
  return <ScrollDown {...props} />;
}

export default withSvgIcon(CustomScrollDown);
