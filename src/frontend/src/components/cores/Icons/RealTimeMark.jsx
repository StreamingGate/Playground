import React from 'react';
import RealTimeMark from '@assets/icons/RealTimeMark.svg';

import withSvgIcon from './withSvgIcon';

function CustomRealTimeMark(props) {
  return <RealTimeMark {...props} />;
}

export default withSvgIcon(CustomRealTimeMark);
