import React from 'react';
import PropTypes from 'prop-types';

import TypographyStyle from './Typography.style';

function Typography({ className, type, children }) {
  return (
    <TypographyStyle.P className={className} type={type}>
      {children}
    </TypographyStyle.P>
  );
}

Typography.propTypes = {
  className: PropTypes.string,
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
  className: '',
  type: 'content',
  children: '',
};

export default Typography;
