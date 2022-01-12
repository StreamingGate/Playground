import React from 'react';
import PropTypes from 'prop-types';

import S from './IconButton.style';

function IconButton({ className, size, children }) {
  return (
    <S.Button className={className} type='button' size={size}>
      {children}
    </S.Button>
  );
}

IconButton.propTypes = {
  className: PropTypes.string,
  size: PropTypes.oneOf(['small', 'large']),
  children: PropTypes.node.isRequired,
};

IconButton.defaultProps = {
  className: '',
  size: 'small',
};

export default IconButton;
