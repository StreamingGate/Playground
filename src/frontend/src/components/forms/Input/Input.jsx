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
    multiLine,
    maxLength,
    ...rest
  } = props;
  return (
    <S.InputContainer>
      {multiLine ? (
        <S.TextArea
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
          rows='1'
          maxLength={maxLength}
          {...rest}
        />
      ) : (
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
      )}
      {error && <S.HelperText type='caption'>{helperText}</S.HelperText>}
    </S.InputContainer>
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
  multiLine: PropTypes.bool,
  maxLength: PropTypes.number,
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
  multiLine: false,
  maxLength: 524288,
  onChange: undefined,
};

export default Input;
