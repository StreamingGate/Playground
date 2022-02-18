import React, { useContext } from 'react';

import * as S from './Dropdown.style';
import { MainLayoutContext } from '@utils/context';
import { modalService } from '@utils/service';

import { Typography, MyVideo, LiveStreaming } from '@components/cores';
import { MakeStreamModal } from '@components/feedbacks/Modals';

function AddVideoDropdown() {
  const { modalState } = useContext(MainLayoutContext);

  const handleAddVideoModalClick = e => {
    e.stopPropagation();
    const { target } = e;

    const button = target.closest('li');

    if (!button) return;

    if (button.id === 'video') {
      modalService.show(MakeStreamModal, { type: 'video' });
    } else if (button.id === 'live') {
      modalService.show(MakeStreamModal, { type: 'live' });
    }
  };

  return (
    <S.AddVideoDropdownContainer onClick={handleAddVideoModalClick}>
      {modalState.addVideo && (
        <S.AddVideoMenus>
          <S.AddVideoMenu id='video'>
            <MyVideo />
            <Typography type='component'>동영상 업로드</Typography>
          </S.AddVideoMenu>
          <S.AddVideoMenu id='live'>
            <LiveStreaming />
            <Typography type='component'>실시간 스트리밍 시작</Typography>
          </S.AddVideoMenu>
        </S.AddVideoMenus>
      )}
    </S.AddVideoDropdownContainer>
  );
}

export default AddVideoDropdown;
