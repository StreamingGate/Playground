import React from 'react';
import PropTypes from 'prop-types';

import S from './IconButton.style';

function IconButton({ className, size, children, onClick }) {
  return (
    <S.Button className={className} type='button' size={size} onClick={onClick}>
      {children}
    </S.Button>
  );
}

IconButton.propTypes = {
  className: PropTypes.string,
  size: PropTypes.oneOf(['small', 'large']),
  children: PropTypes.node.isRequired,
  onClick: PropTypes.func,
};

IconButton.defaultProps = {
  className: '',
  size: 'small',
  onClick: undefined,
};

export default IconButton;
