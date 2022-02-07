import React from 'react';

import Viewers from '@assets/icons/Viewers.svg';

import withSvgIcon from './withSvgIcon';

function CustomViewers(props) {
  return <Viewers {...props} />;
}

export default withSvgIcon(CustomViewers);
