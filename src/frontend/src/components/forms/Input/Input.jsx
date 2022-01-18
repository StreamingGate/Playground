import React from 'react';
import PropTypes from 'prop-types';

import InputStyle from './Input.styles';

function Input({ type, placeholder, value, size, variant, fontSize, fullWidth, onChange }) {
  return (
    <InputStyle.Input
      type={type}
      placeholder={placeholder}
      value={value}
      size={size}
      variant={variant}
      fullWidth={fullWidth}
      fontSize={fontSize}
      onChange={onChange}
    />
  );
}

Input.propTypes = {
  type: PropTypes.oneOf(['text', 'password']),
  placeholder: PropTypes.string,
  value: PropTypes.string,
  size: PropTypes.oneOf(['small', 'large']),
  variant: PropTypes.oneOf(['outlined', 'standard']),
  fontSize: PropTypes.oneOf([
    'title',
    'subtitle',
    'tab',
    'lightTitle',
    'component',
    'content',
    'hightlightCaption',
    'caption',
    'bottomTab',
  ]),
  fullWidth: PropTypes.bool,
  onChange: PropTypes.func,
};

Input.defaultProps = {
  type: 'text',
  placeholder: '',
  value: undefined,
  size: 'small',
  variant: 'outlined',
  fontSize: 'content',
  fullWidth: false,
  onChange: undefined,
};

export default Input;
