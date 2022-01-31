import React, { useContext, useState, useCallback, useRef } from 'react';

import S from './SideFriendList.style';
import { MainLayoutContext } from '@utils/context';

import FriendItem from './FriendItem';
import { BackDrop } from '@components/feedbacks';

const dummyFriends = [
  { isOnline: false, profileImgSrc: '', name: '김하늬' },
  { isOnline: false, profileImgSrc: '', name: '서채희' },
  { isOnline: false, profileImgSrc: '', name: '이우재' },
  { isOnline: false, profileImgSrc: '', name: 'Daniel Radcliffe' },
  { isOnline: false, profileImgSrc: '', name: 'Emma Watson' },
  { isOnline: false, profileImgSrc: '', name: 'Tom Holland' },
  { isOnline: false, profileImgSrc: '', name: 'Rupert Grint' },
  { isOnline: false, profileImgSrc: '', name: '황예지' },
  { isOnline: false, profileImgSrc: '', name: '강슬기' },
  { isOnline: false, profileImgSrc: '', name: '차정원' },
  { isOnline: false, profileImgSrc: '', name: '신류진' },
  { isOnline: false, profileImgSrc: '', name: '이이경' },
  { isOnline: false, profileImgSrc: '', name: 'A' },
  { isOnline: false, profileImgSrc: '', name: 'B' },
  { isOnline: false, profileImgSrc: '', name: 'C' },
  { isOnline: false, profileImgSrc: '', name: 'D' },
  { isOnline: false, profileImgSrc: '', name: 'E' },
  { isOnline: false, profileImgSrc: '', name: 'F' },
  { isOnline: false, profileImgSrc: '', name: 'G' },
  { isOnline: false, profileImgSrc: '', name: 'H' },
  { isOnline: false, profileImgSrc: '', name: 'I' },
  { isOnline: false, profileImgSrc: '', name: 'J' },
];

function SideFriendList() {
  const friendModalRef = useRef(null);
  const { sideFriendState, onToggleSideFriend } = useContext(MainLayoutContext);

  const [selectedFriendIdx, setSelectedFriendIdx] = useState(-1);
  const [friendBottomPos, setFriendBottomPos] = useState(0);
  const [isFriendModalToggle, setFriendModalToggle] = useState(false);

  const handleFriendItemClick = idx => e => {
    const { currentTarget } = e;
    const friendModalHeight = friendModalRef.current.getBoundingClientRect().height;
    const currentTargetPos = currentTarget.getBoundingClientRect();

    if (isFriendModalToggle && selectedFriendIdx === idx) {
      setSelectedFriendIdx(idx);
      setFriendModalToggle(false);
    } else {
      if (idx === dummyFriends.length - 1) {
        setFriendBottomPos(currentTargetPos.bottom - friendModalHeight);
      } else {
        setFriendBottomPos(
          currentTargetPos.y + currentTargetPos.height / 2 - friendModalHeight / 2
        );
      }
      setFriendModalToggle(true);
      setSelectedFriendIdx(idx);
    }
  };

  return (
    <>
      <BackDrop
        isOpen={sideFriendState.open && sideFriendState.backdrop}
        onClick={onToggleSideFriend}
        zIndex={2}
      />
      <S.SideFriendListContainer state={sideFriendState}>
        <S.SideFriendListHeader type='highlightCaption'>친구 목록</S.SideFriendListHeader>
        <S.FriendList>
          {dummyFriends.map(({ isOnline, profileImgSrc, name }, idx) => (
            // 추후 profileImgSrc로 변경
            <FriendItem
              key={name}
              isOnline={isOnline}
              profileImgSrc={profileImgSrc}
              name={name}
              onClick={handleFriendItemClick(idx)}
            />
          ))}
        </S.FriendList>
        <S.FriendModalContainer
          ref={friendModalRef}
          top={friendBottomPos}
          isShow={isFriendModalToggle}
        >
          <S.FriendAvatar size='lg' />
          <S.FriendModalRightDiv>
            <S.FriendModalName type='highlightCaption'>친구이름</S.FriendModalName>
            <S.FriendVideoName type='caption'>시청 중인 영상제목</S.FriendVideoName>
            <S.PlayWithFriendBtn>영상 같이 시청하기</S.PlayWithFriendBtn>
          </S.FriendModalRightDiv>
        </S.FriendModalContainer>
      </S.SideFriendListContainer>
    </>
  );
}

export default SideFriendList;
