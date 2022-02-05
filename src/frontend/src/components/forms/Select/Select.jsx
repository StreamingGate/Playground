import React from 'react';
import PropTypes from 'prop-types';

import * as S from './Select.style';

function Select({ children }) {
  return <S.Select>{children}</S.Select>;
}

Select.propTypes = {
  children: PropTypes.arrayOf(PropTypes.element).isRequired,
};

export default Select;
