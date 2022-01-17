import React from 'react';

import YellowRing from '@assets/icons/YellowRing.svg';
import withSvgIcon from './withSvgIcon';

function CustomYelloRing(props) {
  return <YellowRing {...props} />;
}

export default withSvgIcon(CustomYelloRing);
