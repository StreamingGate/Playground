import React from 'react';

import Send from '@assets/icons/Send.svg';

import withSvgIcon from './withSvgIcon';

function CustomSend(props) {
  return <Send {...props} />;
}

export default withSvgIcon(CustomSend);
