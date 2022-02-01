import React from 'react';

import LiveStreaming from '@assets/icons/LiveStreaming.svg';

import withSvgIcon from './withSvgIcon';

function CustomLiveStreaming(props) {
  return <LiveStreaming {...props} />;
}

export default withSvgIcon(CustomLiveStreaming);
