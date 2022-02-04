import React, { useContext } from 'react';

import * as S from '../Header.style';
import { MainLayoutContext } from '@utils/context';
import { modalService } from '@utils/service';
import { useGetFriendReqList } from '@utils/hook/query';

import { AcceptFriendModal } from '@components/feedbacks/Modals';
import { Typography } from '@components/cores';

const dummyAlarms = [
  { id: 1, content: '김하늬님이 라이브 방송을 시작하셨습니다', time: '지금' },
  { id: 2, content: '서채희님이 회원님의 비디오에 댓글을 남겼습니다', time: '1일' },
  { id: 3, content: '이우재님이 회원님께 친구를 요청하셨습니다', time: '4일' },
];

function AlarmDropdown() {
  const { modalState } = useContext(MainLayoutContext);
  const { data: friendReqList } = useGetFriendReqList('33333333-1234-1234-123456789012');

  const handleAlarmModalClick = e => {
    e.stopPropagation();
    const { target } = e;
    if (target.tagName === 'BUTTON') {
      modalService.show(AcceptFriendModal, { friendReqList });
    }
  };

  return (
    <S.AlarmDropdownContainer onClick={handleAlarmModalClick}>
      {modalState.alarm && (
        <S.AlarmDropdown>
          <S.AlarmTitle>
            <Typography>알림</Typography>
          </S.AlarmTitle>
          <S.AlarmBody>
            <S.AcceptFriendBtn>친구 요청{friendReqList?.result.length}</S.AcceptFriendBtn>
            <S.AlarmList>
              {dummyAlarms.map(alarm => (
                <S.AlarmInfo key={alarm.id}>
                  <S.AlarmAvartar size='sm' />
                  <S.AlarmContent type='caption'>
                    {alarm.content} <span>{alarm.time}</span>
                  </S.AlarmContent>
                </S.AlarmInfo>
              ))}
            </S.AlarmList>
          </S.AlarmBody>
        </S.AlarmDropdown>
      )}
    </S.AlarmDropdownContainer>
  );
}

export default AlarmDropdown;
