import React from 'react';

import ThumbDown from '@assets/icons/ThumbDown.svg';

import withSvgIcon from './withSvgIcon';

function CustomThumbDown(props) {
  return <ThumbDown {...props} />;
}

export default withSvgIcon(CustomThumbDown);
