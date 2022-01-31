import React, { useContext } from 'react';

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
];

function SideFriendList() {
  const { sideFriendState, onToggleSideFriend } = useContext(MainLayoutContext);
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
          {dummyFriends.map(({ isOnline, profileImgSrc, name }) => (
            // 추후 profileImgSrc로 변경
            <FriendItem key={name} isOnline={isOnline} profileImgSrc={profileImgSrc} name={name} />
          ))}
        </S.FriendList>
      </S.SideFriendListContainer>
    </>
  );
}

export default SideFriendList;
