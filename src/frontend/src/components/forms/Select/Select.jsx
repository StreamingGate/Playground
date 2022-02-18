import React from 'react';
import PropTypes from 'prop-types';

import * as S from './Select.style';

function Select({ className, children, onChange, value }) {
  return (
    <S.Select className={className} onChange={onChange} value={value}>
      {children}
    </S.Select>
  );
}

Select.propTypes = {
  className: PropTypes.string,
  onChange: PropTypes.func,
  children: PropTypes.arrayOf(PropTypes.element).isRequired,
  value: PropTypes.string,
};

Select.defaultProps = {
  className: '',
  onChange: undefined,
  value: '',
};

export default Select;
