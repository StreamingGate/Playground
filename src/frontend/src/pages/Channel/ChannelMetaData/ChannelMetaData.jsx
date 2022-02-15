import React, { memo } from 'react';
import { useParams } from 'react-router-dom';

import * as S from './ChannelMetaData.style';
import { useGetChannelInfo } from '@utils/hook/query';

function ChannelMetaData() {
  const { id } = useParams();
  const { data } = useGetChannelInfo(id);

  return (
    <S.ChannelMetaDataContainer>
      <S.ChannelProfile size='xl' imgSrc={data?.profileImage} />
      <S.ChannelInfo>
        <S.ChannelName type='title'>{data?.nickName}</S.ChannelName>
        <S.ChannelNumberData>
          <S.ChannelFriendNum type='caption'>친구 {data?.friendCnt}명</S.ChannelFriendNum>
          <S.ChannelVideoNum type='caption'>동영상 {data?.uploadCnt}개</S.ChannelVideoNum>
        </S.ChannelNumberData>
      </S.ChannelInfo>
      {/* {userId !== data?.} */}
      <S.SubscribeBtn size='sm'>친구 신청</S.SubscribeBtn>
    </S.ChannelMetaDataContainer>
  );
}

export default memo(ChannelMetaData);
