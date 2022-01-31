import React, { useContext } from 'react';
import PropTypes from 'prop-types';

import S from './SideFriendList.style';
import { MainLayoutContext } from '@utils/context';

import FriendItem from './FriendItem';
import { BackDrop } from '@components/feedbacks';

function SideFriendList({ friends }) {
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
          {friends.map(({ isOnline, profileImgSrc, name }) => (
            // 추후 profileImgSrc로 변경
            <FriendItem key={name} isOnline={isOnline} profileImgSrc={profileImgSrc} name={name} />
          ))}
        </S.FriendList>
      </S.SideFriendListContainer>
    </>
  );
}

SideFriendList.propTypes = {
  friends: PropTypes.arrayOf(
    PropTypes.shape({
      isOnline: PropTypes.bool,
      profileImgSrc: PropTypes.string,
      name: PropTypes.string,
    })
  ),
};

SideFriendList.defaultProps = {
  friends: [],
};

export default SideFriendList;
