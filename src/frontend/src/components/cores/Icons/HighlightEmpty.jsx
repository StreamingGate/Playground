import React from 'react';
import HighlightEmpty from '@assets/icons/HighlightEmpty.svg';

import withSvgIcon from './withSvgIcon';

function CustomHighlighEmpty(props) {
  return <HighlightEmpty {...props} />;
}

export default withSvgIcon(CustomHighlighEmpty);
