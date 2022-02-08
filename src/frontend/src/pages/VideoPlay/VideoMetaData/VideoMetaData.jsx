import React, { useState } from 'react';
import PropTypes from 'prop-types';

import * as S from './VideoMetaData.style';

import { IconButton } from '@components/buttons';
import { ThumbUp, ThumbDown, Share, Report } from '@components/cores';

function ActionButton({ element, content, onClick }) {
  return (
    <S.Action>
      <IconButton onClick={onClick}>{element}</IconButton>
      <S.ActionLabel type='caption'>{content}</S.ActionLabel>
    </S.Action>
  );
}

function VideoMetaData({ videoData }) {
  const [isOverviewExpand, setOverviewExpand] = useState(false);

  const handleExpandBtnClick = () => {
    setOverviewExpand(prev => !prev);
  };

  if (!videoData) {
    return null;
  }

  return (
    <S.VideoMetaDataContainer>
      <S.VideoCategory type='caption'>#{videoData.category}</S.VideoCategory>
      <S.VideoTitle type='component'>{videoData.title}</S.VideoTitle>
      <S.VideoInfoContainer>
        <S.WatchPeople type='caption'>6702명 시청 중</S.WatchPeople>
        <S.ActionContainer>
          <ActionButton element={<ThumbUp />} content={`${videoData.likeCnt} 회`} />
          <ActionButton element={<ThumbDown />} content='싫어요' />
          <ActionButton element={<Share />} content='공유' />
          <ActionButton element={<Report />} content='신고' />
        </S.ActionContainer>
      </S.VideoInfoContainer>
      <S.VideoSubInfoContainer>
        <S.MyProfile size='md' imgSrc={videoData.uploaderProfileImage} />
        <S.VideoSubInfo>
          <S.ChannelInfo>
            <S.ChannelName>채널 이름</S.ChannelName>
            <S.SubscribePeople type='bottomTab'>{videoData.subscriberCnt}명</S.SubscribePeople>
          </S.ChannelInfo>
          {videoData.content && (
            <div>
              <S.ContentOverview isExpand={isOverviewExpand}>{videoData.content}</S.ContentOverview>
              <S.ExpandContenOverviewBtn variant='text' onClick={handleExpandBtnClick}>
                {isOverviewExpand ? '간략히' : '더보기'}
              </S.ExpandContenOverviewBtn>
            </div>
          )}
        </S.VideoSubInfo>
        <S.SubScribeBtn>친구 신청</S.SubScribeBtn>
      </S.VideoSubInfoContainer>
    </S.VideoMetaDataContainer>
  );
}

ActionButton.propTypes = {
  element: PropTypes.element.isRequired,
  content: PropTypes.string.isRequired,
  onClick: PropTypes.func.isRequired,
};

export default VideoMetaData;
