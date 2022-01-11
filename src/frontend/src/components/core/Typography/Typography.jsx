import React from 'react';
import PropTypes from 'prop-types';

import TypographyStyle from './Typography.style';

function Typography({ type, children }) {
  return <TypographyStyle.P type={type}>{children}</TypographyStyle.P>;
}

Typography.propTypes = {
  type: PropTypes.oneOf([
    'title',
    'subtitle',
    'tab',
    'lightTitle',
    'component',
    'content',
    'highlightCaption',
    'caption',
    'bottomTab',
  ]),
  children: PropTypes.node,
};

Typography.defaultProps = {
  type: 'content',
  children: '',
};

export default Typography;
