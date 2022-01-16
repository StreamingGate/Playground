import React from 'react';
import PropTypes from 'prop-types';

import S from './BackDrop.style';

function BackDrop({ isOpen, onClick }) {
  return <S.BackDropContainer isOpen={isOpen} onClick={onClick} />;
}

BackDrop.propTypes = {
  isOpen: PropTypes.bool,
  onClick: PropTypes.func,
};

BackDrop.defaultProps = {
  isOpen: false,
  onClick: undefined,
};

export default BackDrop;
