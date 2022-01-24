import React from 'react';

import * as S from './Modal.style';
import { modalService } from '@utils/service';

import { Dialog } from '@components/feedbacks';
import { Typography } from '@components/cores';

function AdviseModal(args) {
  const modal = modalService.useModal();
  return (
    <Dialog open={modal.visible}>
      <S.AdviseModalContainer>
        <S.AdviseModalContent>
          <Typography type='component'>{args.content}</Typography>
        </S.AdviseModalContent>
      </S.AdviseModalContainer>
    </Dialog>
  );
}

export default modalService.create(AdviseModal);
