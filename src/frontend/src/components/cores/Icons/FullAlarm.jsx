import React from 'react';

import FullAlarm from '@assets/icons/FullAlarm.svg';

import withSvgIcon from './withSvgIcon';

function CustomFullAlarm(props) {
  return <FullAlarm {...props} />;
}

export default withSvgIcon(CustomFullAlarm);
