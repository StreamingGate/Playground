import React from 'react';
import PropTypes from 'prop-types';

import ButtonStyle from './Button.style';

function Button({ className, id, variant, children, color, size, fullWidth, onClick, disabled }) {
  return (
    <ButtonStyle.B
      className={className}
      id={id}
      type='button'
      variant={variant}
      color={color}
      size={size}
      fullWidth={fullWidth}
      onClick={onClick}
      disabled={disabled}
    >
      {children}
    </ButtonStyle.B>
  );
}

Button.propTypes = {
  className: PropTypes.string,
  id: PropTypes.string,
  variant: PropTypes.oneOf(['contained', 'outlined', 'text']),
  children: PropTypes.node,
  color: PropTypes.oneOf(['pgBlue', 'pgRed', 'pgOrange']),
  size: PropTypes.oneOf(['sm', 'md', 'lg']),
  fullWidth: PropTypes.bool,
  onClick: PropTypes.func,
  disabled: PropTypes.bool,
};

Button.defaultProps = {
  className: '',
  id: '',
  variant: 'contained',
  children: '',
  color: 'pgOrange',
  size: 'md',
  fullWidth: false,
  onClick: null,
  disabled: false,
};

export default Button;
