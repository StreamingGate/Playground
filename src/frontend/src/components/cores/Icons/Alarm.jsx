import React from 'react';
import Alarm from '@assets/icons/Alarm.svg';

import withSvgIcon from './withSvgIcon';

function CustomAlarm(props) {
  return <Alarm {...props} />;
}

export default withSvgIcon(CustomAlarm);
