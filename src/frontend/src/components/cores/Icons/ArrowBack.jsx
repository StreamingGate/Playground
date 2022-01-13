import React from 'react';
import ArrowBack from '@assets/icons/ArrowBack.svg';

import withSvgIcon from './withSvgIcon';

function CustomArrowBack(props) {
  return <ArrowBack {...props} />;
}

export default withSvgIcon(CustomArrowBack);
