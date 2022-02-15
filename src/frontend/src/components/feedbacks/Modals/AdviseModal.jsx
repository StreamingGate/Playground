import React from 'react';
import PropTypes from 'prop-types';

import * as S from './Modal.style';
import { modalService } from '@utils/service';

import { Dialog } from '@components/feedbacks';
import { Button } from '@components/buttons';
import { Typography } from '@components/cores';

function AdviseModal({
  content,
  type,
  btnContent,
  cancelBtnContent,
  btnPos,
  onClick,
  onCancelClick,
}) {
  const modal = modalService.useModal();

  const handleHideBtnClick = () => {
    if (onClick) {
      onClick();
    }
    modal.hide();
  };

  const handleCancelBtnClick = () => {
    if (onCancelClick) {
      onCancelClick();
    }
    modal.hide();
  };

  return (
    <Dialog open={modal.visible} zIndex={3}>
      <S.AdviseModalContainer>
        <S.AdviseModalContent>
          <Typography type='component'>{content}</Typography>
        </S.AdviseModalContent>
        <S.AdviseModalAction position={btnPos}>
          {type === 'cancel' && (
            <S.CancelButton variant='text' onClick={handleCancelBtnClick}>
              {cancelBtnContent}
            </S.CancelButton>
          )}
          <Button onClick={handleHideBtnClick}>{btnContent}</Button>
        </S.AdviseModalAction>
      </S.AdviseModalContainer>
    </Dialog>
  );
}

AdviseModal.propTypes = {
  content: PropTypes.string.isRequired,
  btnContent: PropTypes.string,
  btnPos: PropTypes.oneOf(['left', 'center', 'right']),
  onClick: PropTypes.func,
};

AdviseModal.defaultProps = {
  btnContent: '확인',
  btnPos: 'right',
  onClick: null,
};

export default modalService.create(AdviseModal);
