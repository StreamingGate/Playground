import React from 'react';
import ArrowRight from '@assets/icons/ArrowRight.svg';

import withSvgIcon from './withSvgIcon';

function CustomArrowRight(props) {
  return <ArrowRight {...props} />;
}

export default withSvgIcon(CustomArrowRight);
