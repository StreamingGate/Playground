import React from 'react';
import PropTypes from 'prop-types';

import S from './SideFriendList.style';

import FriendItem from './FriendItem';

function SideFriendList({ friends }) {
  return (
    <S.SideFriendListContainer>
      <S.SideFriendListHeader type='highlightCaption'>친구 목록</S.SideFriendListHeader>
      <S.FriendList>
        {friends.map(({ isOnline, profileImgSrc, name }) => (
          // 추후 profileImgSrc로 변경
          <FriendItem key={name} isOnline={isOnline} profileImgSrc={profileImgSrc} name={name} />
        ))}
      </S.FriendList>
    </S.SideFriendListContainer>
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
