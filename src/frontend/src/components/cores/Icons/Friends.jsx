import React from 'react';
import Friends from '@assets/icons/Friends.svg';

import withSvgIcon from './withSvgIcon';

function CustomFriends(props) {
  return <Friends {...props} />;
}

export default withSvgIcon(CustomFriends);
