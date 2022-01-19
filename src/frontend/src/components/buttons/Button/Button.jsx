import React from 'react';
import PropTypes from 'prop-types';

import ButtonStyle from './Button.style';

function Button({ variant, children, color, size, fullWidth, onClick, className }) {
  return (
    <ButtonStyle.B
      className={className}
      type='button'
      variant={variant}
      color={color}
      size={size}
      fullWidth={fullWidth}
      onClick={onClick}
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
};

Button.defaultProps = {
  className: '',
  variant: 'contained',
  children: '',
  color: 'pgOrange',
  size: 'md',
  fullWidth: false,
  onClick: null,
};

export default Button;
