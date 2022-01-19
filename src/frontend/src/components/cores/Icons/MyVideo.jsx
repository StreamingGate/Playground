import React from 'react';
import MyVideo from '@assets/icons/MyVideo.svg';

import withSvgIcon from './withSvgIcon';

function CustomMyVideo(props) {
  return <MyVideo {...props} />;
}

export default withSvgIcon(CustomMyVideo);
