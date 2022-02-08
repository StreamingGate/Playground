import React from 'react';

import Like from '@assets/icons/Like.svg';

import withSvgIcon from './withSvgIcon';

function CustomLike(props) {
  return <Like {...props} />;
}

export default withSvgIcon(CustomLike);
