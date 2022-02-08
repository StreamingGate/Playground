import React from 'react';
import PropTypes from 'prop-types';

import S from './IconButton.style';

function IconButton({ className, name, size, disabled, children, onClick }) {
  return (
    <S.Button
      className={className}
      data-name={name}
      type='button'
      size={size}
      disabled={disabled}
      onClick={onClick}
    >
      {children}
    </S.Button>
  );
}

IconButton.propTypes = {
  className: PropTypes.string,
  name: PropTypes.string,
  size: PropTypes.oneOf(['small', 'large']),
  children: PropTypes.node.isRequired,
  disabled: PropTypes.bool,
  onClick: PropTypes.func,
};

IconButton.defaultProps = {
  className: '',
  name: '',
  size: 'small',
  disabled: false,
  onClick: undefined,
};

export default IconButton;
