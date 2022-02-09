import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import PropTypes from 'prop-types';

import * as S from './VideoMetaData.style';
import { lStorageService } from '@utils/service';
import { useVideoAction } from '@utils/hook/query';

import { IconButton } from '@components/buttons';
import { Share, Report } from '@components/cores';

function ActionButton({ element, content, onClick }) {
  return (
    <S.Action>
      <IconButton onClick={onClick}>{element}</IconButton>
      <S.ActionLabel type='caption'>{content}</S.ActionLabel>
    </S.Action>
  );
}

function VideoMetaData({ videoData, playType }) {
  const { id } = useParams();
  const userId = lStorageService.getItem('uuid');

  const [isOverviewExpand, setOverviewExpand] = useState(false);
  const [preferToggleState, setPreferToggleState] = useState({ liked: false, disliked: false });
  const [likeCount, setLikeCount] = useState(0);

  useEffect(() => {
    if (videoData?.liked !== undefined) {
      const { liked, disliked, likeCnt } = videoData;
      setLikeCount(likeCnt);
      setPreferToggleState({ liked, disliked });
    }
  }, [videoData]);

  const handleExpandBtnClick = () => {
    setOverviewExpand(prev => !prev);
  };

  const videoPreferUiUpdate = actionType => {
    if (actionType === 'LIKE') {
      if (preferToggleState.liked) {
        setLikeCount(prev => prev - 1);
        setPreferToggleState(prev => ({ ...prev, liked: false }));
      } else {
        setLikeCount(prev => prev + 1);
        setPreferToggleState(prev => ({ ...prev, liked: true }));
      }
    } else if (actionType === 'DISLIKE') {
      if (videoData.disliked) {
        setPreferToggleState(prev => ({ ...prev, disliked: false }));
      } else {
        setPreferToggleState(prev => ({ ...prev, disliked: true }));
      }
    }
  };

  const { mutate } = useVideoAction(videoPreferUiUpdate);

  const handleLikeBtnClick = () => {
    const actionBody = {
      id,
      type: playType.current === 'video' ? 0 : 1,
      action: 'LIKE',
      uuid: userId,
    };

    if (preferToggleState.liked) {
      mutate({
        type: 'delete',
        actionBody,
      });
    } else {
      mutate({
        type: 'post',
        actionBody,
      });
    }
  };

  const handleDisLikeBtnClick = () => {
    const actionBody = {
      id,
      type: playType.current === 'video' ? 0 : 1,
      action: 'DISLIKE',
      uuid: userId,
    };

    if (preferToggleState.disliked) {
      mutate({
        type: 'delete',
        actionBody,
      });
    } else {
      mutate({
        type: 'post',
        actionBody,
      });
    }
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
          <ActionButton
            onClick={handleLikeBtnClick}
            element={<S.ThumbUpIcon isToggle={preferToggleState.liked} />}
            content={`${likeCount} 회`}
          />
          <ActionButton
            onClick={handleDisLikeBtnClick}
            element={<S.ThumbDownIcon isToggle={preferToggleState.disliked} />}
            content='싫어요'
          />
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
