import React from 'react';
import PropTypes from 'prop-types';

import S from './BackDrop.style';

function BackDrop({ isOpen, zIndex, onClick }) {
  return <S.BackDropContainer isOpen={isOpen} zIndex={zIndex} onClick={onClick} />;
}

BackDrop.propTypes = {
  isOpen: PropTypes.bool,
  zIndex: PropTypes.number,
  onClick: PropTypes.func,
};

BackDrop.defaultProps = {
  isOpen: false,
  zIndex: 1,
  onClick: undefined,
};

export default BackDrop;
