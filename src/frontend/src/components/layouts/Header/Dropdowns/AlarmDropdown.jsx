import React, { useContext } from 'react';

import * as S from './Dropdown.style';
import { MainLayoutContext } from '@utils/context';
import { modalService } from '@utils/service';
import { useGetFriendReqList, useGetNotiList } from '@utils/hook/query';

import { AcceptFriendModal } from '@components/feedbacks/Modals';
import { Typography } from '@components/cores';

function parseAlarm(alarm) {
  const { notiType, content } = alarm;

  const parsedContent = JSON.parse(content);
  const { sender, profileImage } = parsedContent;

  let message = '';
  switch (notiType) {
    case 'STREAMING':
      message = `${sender}님이 실시간 스트리밍을 시작했습니다`;
      break;
    case 'FRIEND_REQUEST':
      message = `${sender}님이 친구를 요청했습니다`;
      break;
    default:
      message = `${sender}님이 '${parsedContent.title}'에 좋아요를 눌렀습니다`;
      break;
  }
  return { message, profileImage };
}

function AlarmDropdown() {
  const { modalState } = useContext(MainLayoutContext);
  const { data: friendReqList } = useGetFriendReqList('33333333-1234-1234-123456789012');
  const { data: notiList } = useGetNotiList('33333333-1234-1234-123456789012');

  const handleAlarmModalClick = e => {
    e.stopPropagation();
    const { target } = e;
    if (target.tagName === 'BUTTON') {
      modalService.show(AcceptFriendModal, {
        myId: '33333333-1234-1234-123456789012',
      });
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
            <S.AcceptFriendBtnContainer>
              <S.AcceptFriendBtn>친구 요청{friendReqList?.result.length}</S.AcceptFriendBtn>
            </S.AcceptFriendBtnContainer>
            <S.AlarmList>
              {notiList?.result.map(alarm => {
                const { message, profileImage } = parseAlarm(alarm);
                return (
                  <S.AlarmInfo key={alarm.id}>
                    <S.AlarmAvartar size='sm' imgSrc={profileImage} />
                    <S.AlarmContent type='caption'>
                      {message} <span>{alarm.time}</span>
                    </S.AlarmContent>
                  </S.AlarmInfo>
                );
              })}
            </S.AlarmList>
          </S.AlarmBody>
        </S.AlarmDropdown>
      )}
    </S.AlarmDropdownContainer>
  );
}

export default AlarmDropdown;
