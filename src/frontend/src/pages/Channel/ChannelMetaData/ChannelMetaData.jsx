import React, { memo } from 'react';

import * as S from './ChannelMetaData.style';

function ChannelMetaData() {
  return (
    <S.ChannelMetaDataContainer>
      <S.ChannelProfile size='xl' />
      <S.ChannelInfo>
        <S.ChannelName type='title'>채널이름</S.ChannelName>
        <S.ChannelNumberData>
          <S.ChannelFriendNum type='caption'>친구 2.01천명</S.ChannelFriendNum>
          <S.ChannelVideoNum type='caption'>동영상 3개</S.ChannelVideoNum>
        </S.ChannelNumberData>
      </S.ChannelInfo>
      <S.SubscribeBtn size='sm'>친구 신청</S.SubscribeBtn>
    </S.ChannelMetaDataContainer>
  );
}

export default memo(ChannelMetaData);
