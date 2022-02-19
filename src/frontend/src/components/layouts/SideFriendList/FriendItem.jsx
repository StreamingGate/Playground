import React, { memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './SideFriendList.style';

import { Avatar } from '@components/dataDisplays';

function FriendItem({ isOnline, userId, onClick, name, dataSet }) {
  return (
    <S.FriendItem onClick={onClick} data-name={dataSet}>
      <S.FriendAvatarContainer>
        <Avatar size='xs' imgSrc={`${process.env.REACT_APP_PROFILE_IMAGE}${userId}`} />
        {isOnline === true && <S.OnlineMark />}
      </S.FriendAvatarContainer>
      <S.FriendName type='caption'>{name}</S.FriendName>
    </S.FriendItem>
  );
}

FriendItem.propTypes = {
  isOnline: PropTypes.bool.isRequired,
  dataSet: PropTypes.string,
  name: PropTypes.string.isRequired,
  onClick: PropTypes.func,
};

FriendItem.defaultProps = {
  profileImgSrc: '',
  dataSet: '',
  onClick: undefined,
};

export default memo(FriendItem);
