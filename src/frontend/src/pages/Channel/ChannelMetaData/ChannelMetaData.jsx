import React, { memo, useState } from 'react';
import { useParams } from 'react-router-dom';

import * as S from './ChannelMetaData.style';
import { lStorageService, modalService } from '@utils/service';
import { useGetChannelInfo, useReqFriend } from '@utils/hook/query';

import { AdviseModal } from '@components/feedbacks/Modals';

function ChannelMetaData() {
  const userId = lStorageService.getItem('uuid');
  const { id } = useParams();
  const { data } = useGetChannelInfo(id);

  const [disabled, setDisabled] = useState(false);

  const handleFriendReqSucces = data => {
    const { errorCode, message } = data;
    if (errorCode) {
      modalService.show(AdviseModal, { content: message });
    } else {
      modalService.show(AdviseModal, { content: '친구신청이 완료 되었습니다' });
    }
    setDisabled(true);
  };

  const { mutate } = useReqFriend(handleFriendReqSucces);

  const handleFriendReqBtnClick = () => {
    mutate(id);
  };

  return (
    <S.ChannelMetaDataContainer>
      <S.ChannelProfile size='xl' imgSrc={`${process.env.REACT_APP_PROFILE_IMAGE}${id}`} />
      <S.ChannelInfo>
        <S.ChannelName type='title'>{data?.nickName}</S.ChannelName>
        <S.ChannelNumberData>
          <S.ChannelFriendNum type='caption'>친구 {data?.friendCnt}명</S.ChannelFriendNum>
          <S.ChannelVideoNum type='caption'>동영상 {data?.uploadCnt}개</S.ChannelVideoNum>
        </S.ChannelNumberData>
      </S.ChannelInfo>
      {userId !== data?.uuid && (
        <S.SubscribeBtn size='sm' disabled={disabled} onClick={handleFriendReqBtnClick}>
          친구 신청
        </S.SubscribeBtn>
      )}
    </S.ChannelMetaDataContainer>
  );
}

export default memo(ChannelMetaData);
