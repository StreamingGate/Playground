import React from 'react';

import Mute from '@assets/icons/Mute.svg';

import withSvgIcon from './withSvgIcon';

function CustomMute(props) {
  return <Mute {...props} />;
}

export default withSvgIcon(CustomMute);
