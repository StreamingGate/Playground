import React from 'react';
import ThumbUp from '@assets/icons/ThumbUp.svg';

import withSvgIcon from './withSvgIcon';

function CustomThumbUp(props) {
  return <ThumbUp {...props} />;
}

export default withSvgIcon(CustomThumbUp);
