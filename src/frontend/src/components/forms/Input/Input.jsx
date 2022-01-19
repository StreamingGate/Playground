import React from 'react';
import PropTypes from 'prop-types';

import InputStyle from './Input.styles';

function Input({
  className,
  type,
  placeholder,
  value,
  size,
  variant,
  fontSize,
  fullWidth,
  onChange,
}) {
  return (
    <InputStyle.Input
      className={className}
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
  className: PropTypes.string,
  type: PropTypes.oneOf(['text', 'password', 'file']),
  placeholder: PropTypes.string,
  value: PropTypes.string,
  size: PropTypes.oneOf(['sm', 'md', 'lg']),
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
  className: '',
  type: 'text',
  placeholder: '',
  value: undefined,
  size: 'md',
  variant: 'outlined',
  fontSize: 'content',
  fullWidth: false,
  onChange: undefined,
};

export default Input;
