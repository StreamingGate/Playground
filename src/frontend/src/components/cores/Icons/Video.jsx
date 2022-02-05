import React from 'react';

import Video from '@assets/icons/Video.svg';

import withSvgIcon from './withSvgIcon';

function CustomVideo(props) {
  return <Video {...props} />;
}

export default withSvgIcon(CustomVideo);
