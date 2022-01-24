import React from 'react';
import PropTypes from 'prop-types';

import ButtonStyle from './Button.style';

function Button({ className, variant, children, color, size, fullWidth, onClick, disabled }) {
  return (
    <ButtonStyle.B
      className={className}
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
  variant: PropTypes.oneOf(['contained', 'outlined']),
  children: PropTypes.node,
  color: PropTypes.oneOf(['youtubeRed', 'pgBlue', 'pgOrange']),
  size: PropTypes.oneOf(['sm', 'md', 'lg']),
  fullWidth: PropTypes.bool,
  onClick: PropTypes.func,
  disabled: PropTypes.bool,
};

Button.defaultProps = {
  className: '',
  variant: 'contained',
  children: '',
  color: 'pgOrange',
  size: 'md',
  fullWidth: false,
  onClick: null,
  disabled: false,
};

export default Button;
