import React from 'react';

import WhiteShare from '@assets/icons/WhiteShare.svg';

import withSvgIcon from './withSvgIcon';

function CustomWhiteShare(props) {
  return <WhiteShare {...props} />;
}

export default withSvgIcon(CustomWhiteShare);
