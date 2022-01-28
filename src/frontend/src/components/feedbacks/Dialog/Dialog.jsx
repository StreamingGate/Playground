import React from 'react';
import PropTypes from 'prop-types';

import * as S from './Dialog.style';

import { BackDrop } from '@components/feedbacks';

function Dialog({ open, onClose, maxWidth, children, zIndex }) {
  return (
    <>
      <BackDrop isOpen={open} onClick={onClose} zIndex={zIndex} />
      <S.DialogContainer isOpen={open} zIndex={zIndex + 1}>
        <S.DialogContent maxWidth={maxWidth}>{children}</S.DialogContent>
      </S.DialogContainer>
    </>
  );
}

Dialog.propTypes = {
  open: PropTypes.bool,
  onClose: PropTypes.func,
  maxWidth: PropTypes.oneOf(['sm', 'md', 'lg', 'xl']),
  zIndex: PropTypes.number,
  children: PropTypes.element.isRequired,
};

Dialog.defaultProps = {
  open: false,
  onClose: null,
  maxWidth: 'sm',
  zIndex: 1,
};

export default Dialog;
