import React from 'react';
import ArrowLeft from '@assets/icons/ArrowLeft.svg';

import withSvgIcon from './withSvgIcon';

function CustomArrowLeft(props) {
  return <ArrowLeft {...props} />;
}

export default withSvgIcon(CustomArrowLeft);
