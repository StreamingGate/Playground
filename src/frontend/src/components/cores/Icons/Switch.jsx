import React from 'react';

import Switch from '@assets/icons/Switch.svg';

import withSvgIcon from './withSvgIcon';

function CustomSwitch(props) {
  return <Switch {...props} />;
}

export default withSvgIcon(CustomSwitch);
