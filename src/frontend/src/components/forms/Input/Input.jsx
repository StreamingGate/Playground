import React, { forwardRef } from 'react';
import PropTypes from 'prop-types';

import * as S from './Input.styles';

const Input = forwardRef((props, ref) => {
  const {
    className,
    type,
    error,
    helperText,
    placeholder,
    value,
    size,
    variant,
    fontSize,
    fullWidth,
    onChange,
    ...rest
  } = props;
  return (
    <>
      <S.Input
        className={className}
        ref={ref}
        type={type}
        placeholder={placeholder}
        value={value}
        size={size}
        variant={variant}
        fullWidth={fullWidth}
        fontSize={fontSize}
        onChange={onChange}
        {...rest}
      />
      {error && <S.HelperText type='caption'>{helperText}</S.HelperText>}
    </>
  );
});

Input.propTypes = {
  className: PropTypes.string,
  type: PropTypes.oneOf(['text', 'password', 'file']),
  error: PropTypes.bool,
  helperText: PropTypes.string,
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
  error: false,
  helperText: '',
  placeholder: '',
  value: undefined,
  size: 'md',
  variant: 'outlined',
  fontSize: 'content',
  fullWidth: false,
  onChange: undefined,
};

export default Input;
