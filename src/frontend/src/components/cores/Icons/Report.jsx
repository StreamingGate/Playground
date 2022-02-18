import React from 'react';

import Report from '@assets/icons/Report.svg';

import withSvgIcon from './withSvgIcon';

function CustomReport(props) {
  return <Report {...props} />;
}

export default withSvgIcon(CustomReport);
