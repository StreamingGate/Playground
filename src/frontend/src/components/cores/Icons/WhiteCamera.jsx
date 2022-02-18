import React from 'react';

import WhiteCamera from '@assets/icons/WhiteCamera.svg';

import withSvgIcon from './withSvgIcon';

function CustomWhiteCamera(props) {
  return <WhiteCamera {...props} />;
}

export default withSvgIcon(CustomWhiteCamera);
