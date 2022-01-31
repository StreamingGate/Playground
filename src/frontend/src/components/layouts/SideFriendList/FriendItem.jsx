import React, { memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './SideFriendList.style';

import { Avatar } from '@components/dataDisplays';

function FriendItem({ isOnline, profileImgSrc, onClick, name, onMouseOver }) {
  return (
    <S.FriendItem onMouseOver={onMouseOver} onClick={onClick}>
      <Avatar size='xs' imgSrc={!profileImgSrc ? undefined : profileImgSrc} />
      <S.FriendName type='caption'>{name}</S.FriendName>
    </S.FriendItem>
  );
}

FriendItem.propTypes = {
  isOnline: PropTypes.bool.isRequired,
  name: PropTypes.string.isRequired,
  profileImgSrc: PropTypes.string,
  onClick: PropTypes.func,
};

FriendItem.defaultProps = {
  profileImgSrc: '',
  onClick: undefined,
};

export default memo(FriendItem);
