import React from 'react';
import PropTypes from 'prop-types';

import S from './BackDrop.style';

function BackDrop({ isOpen, zIndex, onClick, backgroundColor }) {
  return (
    <S.BackDropContainer
      isOpen={isOpen}
      zIndex={zIndex}
      backgroundColor={backgroundColor}
      onClick={onClick}
    />
  );
}

BackDrop.propTypes = {
  isOpen: PropTypes.bool,
  zIndex: PropTypes.number,
  onClick: PropTypes.func,
  backgroundColor: PropTypes.string,
};

BackDrop.defaultProps = {
  isOpen: false,
  zIndex: 1,
  onClick: undefined,
  backgroundColor: undefined,
};

export default BackDrop;
