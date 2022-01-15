import React, { memo } from 'react';
import PropTypes from 'prop-types';

import S from './SideFriendList.style';

import { Avatar } from '@components/dataDisplays';

function FriendItem({ isOnline, profileImgSrc, name }) {
  return (
    <S.FriendItem>
      <Avatar size='small' imgSrc={profileImgSrc} />
      <S.FriendName type='caption'>{name}</S.FriendName>
    </S.FriendItem>
  );
}

FriendItem.propTypes = {
  isOnline: PropTypes.bool.isRequired,
  name: PropTypes.string.isRequired,
  profileImgSrc: PropTypes.string,
};

FriendItem.defaultProps = {
  profileImgSrc: '',
};

export default memo(FriendItem);
