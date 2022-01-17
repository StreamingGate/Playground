import React from 'react';

import Share from '@assets/icons/Share.svg';

import withSvgIcon from './withSvgIcon';

function CustomShare(props) {
  return <Share {...props} />;
}

export default withSvgIcon(CustomShare);
