import React from 'react';

import * as S from './Modal.style';
import { modalService } from '@utils/service';

import { Dialog } from '@components/feedbacks';
import { Button } from '@components/buttons';
import { Typography } from '@components/cores';

function AdviseModal(args) {
  const { content } = args;
  const modal = modalService.useModal();
  return (
    <Dialog open={modal.visible}>
      <S.AdviseModalContainer>
        <S.AdviseModalContent>
          <Typography type='component'>{content}</Typography>
        </S.AdviseModalContent>
        <S.AdviseModalAction>
          <Button onClick={modal.hide}>확인</Button>
        </S.AdviseModalAction>
      </S.AdviseModalContainer>
    </Dialog>
  );
}

export default modalService.create(AdviseModal);
