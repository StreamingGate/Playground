import React, { memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './SideFriendList.style';

import { Avatar } from '@components/dataDisplays';

function FriendItem({ isOnline, profileImgSrc, onClick, name, dataSet }) {
  return (
    <S.FriendItem onClick={onClick} data-name={dataSet}>
      <Avatar size='xs' imgSrc={!profileImgSrc ? undefined : profileImgSrc} />
      <S.FriendName type='caption'>
        {name} {isOnline === true ? '온라인' : '오프라인'}
      </S.FriendName>
    </S.FriendItem>
  );
}

FriendItem.propTypes = {
  isOnline: PropTypes.bool.isRequired,
  dataSet: PropTypes.string,
  name: PropTypes.string.isRequired,
  profileImgSrc: PropTypes.string,
  onClick: PropTypes.func,
};

FriendItem.defaultProps = {
  profileImgSrc: '',
  dataSet: '',
  onClick: undefined,
};

export default memo(FriendItem);
