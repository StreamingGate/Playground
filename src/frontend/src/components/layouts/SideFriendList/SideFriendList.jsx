import React, { useEffect, useContext, useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';

import * as S from './SideFriendList.style';
import { useStatusSocket } from '@utils/hook';
import { MainLayoutContext } from '@utils/context';

import FriendItem from './FriendItem';
import { BackDrop } from '@components/feedbacks';

function SideFriendList() {
  const friendModalRef = useRef(null);
  const { sideFriendState, onToggleSideFriend, onToggleModal, modalState } =
    useContext(MainLayoutContext);

  const [selectedFriendIdx, setSelectedFriendIdx] = useState(-1);
  const [friendBottomPos, setFriendBottomPos] = useState(0);
  const [isFriendModalToggle, setFriendModalToggle] = useState(false);

  const { friendStatus } = useStatusSocket();
  const navigate = useNavigate();

  const handleFriendModalClose = () => {
    setFriendModalToggle(false);
  };

  useEffect(() => {
    if (isFriendModalToggle) {
      window.addEventListener('click', handleFriendModalClose);
    }
    return () => {
      window.removeEventListener('click', handleFriendModalClose);
    };
  }, [isFriendModalToggle]);

  const handleFriendItemClick = idx => e => {
    const { currentTarget } = e;
    const friendModalHeight = friendModalRef.current.getBoundingClientRect().height;
    const currentTargetPos = currentTarget.getBoundingClientRect();

    if (modalState.friend && selectedFriendIdx === idx) {
      setSelectedFriendIdx(idx);
      onToggleModal(e);
    } else {
      if (idx === friendStatus.length - 1) {
        setFriendBottomPos(currentTargetPos.bottom - friendModalHeight);
      } else {
        setFriendBottomPos(
          currentTargetPos.y + currentTargetPos.height / 2 - friendModalHeight / 2
        );
      }
      onToggleModal(e);
      setSelectedFriendIdx(idx);
    }
  };

  const handleViewWithFriendBtnClick = e => {
    e.stopPropagation();
    const { id, type } = friendStatus[selectedFriendIdx];
    if (type === 0) {
      navigate(`/video-play/${id}`);
    } else if (type === 1) {
      navigate(`/live-play/${id}`);
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
          {friendStatus.map(({ profileImage, nickname, status }, idx) => (
            <FriendItem
              key={`${profileImage}_${nickname}`}
              dataSet='friend'
              isOnline={status}
              profileImgSrc={profileImage}
              name={nickname}
              onClick={handleFriendItemClick(idx)}
            />
          ))}
        </S.FriendList>
        <S.FriendModalContainer
          ref={friendModalRef}
          top={friendBottomPos}
          isShow={modalState.friend}
          onClick={handleViewWithFriendBtnClick}
        >
          <S.FriendAvatar size='lg' />
          <S.FriendModalRightDiv>
            <S.FriendModalName type='highlightCaption'>
              {friendStatus[selectedFriendIdx]?.nickname}
            </S.FriendModalName>
            <S.FriendVideoName type='caption'>
              {friendStatus[selectedFriendIdx]?.title}
            </S.FriendVideoName>
            <S.PlayWithFriendBtn
              disabled={!friendStatus[selectedFriendIdx]?.id}
              onClick={handleViewWithFriendBtnClick}
            >
              영상 같이 시청하기
            </S.PlayWithFriendBtn>
          </S.FriendModalRightDiv>
        </S.FriendModalContainer>
      </S.SideFriendListContainer>
    </>
  );
}

export default SideFriendList;
