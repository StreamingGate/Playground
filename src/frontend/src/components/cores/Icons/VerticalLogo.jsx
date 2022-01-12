import React from 'react';
import VerticalLogo from '@assets/icons/VerticalLogo.svg';

import withSvgIcon from './withSvgIcon';

function CustomVerticalLogo(props) {
  return <VerticalLogo {...props} />;
}

export default withSvgIcon(CustomVerticalLogo);
