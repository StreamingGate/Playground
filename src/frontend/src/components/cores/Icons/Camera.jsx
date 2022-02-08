import React from 'react';

import Camera from '@assets/icons/Camera.svg';

import withSvgIcon from './withSvgIcon';

function CustomCamera(props) {
  return <Camera {...props} />;
}

export default withSvgIcon(CustomCamera);
