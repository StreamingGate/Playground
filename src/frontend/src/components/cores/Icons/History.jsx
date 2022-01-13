import React from 'react';
import History from '@assets/icons/History.svg';

import withSvgIcon from './withSvgIcon';

function CustomHistory(props) {
  return <History {...props} />;
}

export default withSvgIcon(CustomHistory);
