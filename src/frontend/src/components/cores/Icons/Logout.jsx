import React from 'react';

import Logout from '@assets/icons/Logout.svg';

import withSvgIcon from './withSvgIcon';

function CustomLogout(props) {
  return <Logout {...props} />;
}

export default withSvgIcon(CustomLogout);
