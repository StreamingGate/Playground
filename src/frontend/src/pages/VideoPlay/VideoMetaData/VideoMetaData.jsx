import React, { useEffect, useState, useContext, useRef } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import PropTypes from 'prop-types';

import * as S from './VideoMetaData.style';
import { ChatInfoContext } from '@utils/context';
import { lStorageService, modalService, mediaService } from '@utils/service';
import { useVideoAction, useReqFriend } from '@utils/hook/query';

import { IconButton } from '@components/buttons';
import { Share, Report } from '@components/cores';
import { AdviseModal } from '@components/feedbacks/Modals';

function ActionButton({ element, content, onClick }) {
  return (
    <S.Action>
      <IconButton onClick={onClick}>{element}</IconButton>
      <S.ActionLabel type='caption'>{content}</S.ActionLabel>
    </S.Action>
  );
}

function VideoMetaData({ videoData, playType }) {
  const { curUserCount } = useContext(ChatInfoContext);

  const { id } = useParams();
  const userId = lStorageService.getItem('uuid');
  const navigate = useNavigate();

  const [uploaderId, setUploaderId] = useState('');
  const [isOverviewExpand, setOverviewExpand] = useState(false);
  const [preferToggleState, setPreferToggleState] = useState({ liked: false, disliked: false });
  const [likeCount, setLikeCount] = useState(0);
  const [disabled, setDisabled] = useState(false);

  useEffect(() => {
    if (videoData?.liked !== undefined) {
      const { liked, disliked, likeCnt } = videoData;
      setLikeCount(likeCnt);
      setPreferToggleState({ liked, disliked });
    }

    if (playType.current === 'video') {
      setUploaderId(videoData?.uploaderUuid);
    } else if (playType.current === 'live') {
      setUploaderId(videoData?.hostUuid);
    }
  }, [videoData]);

  const handleExpandBtnClick = () => {
    setOverviewExpand(prev => !prev);
  };

  const handleVideoActionSuccess = actionType => {
    if (actionType === 'LIKE') {
      if (preferToggleState.liked) {
        setLikeCount(prev => prev - 1);
        setPreferToggleState(prev => ({ ...prev, liked: false }));
      } else {
        setLikeCount(prev => prev + 1);
        setPreferToggleState({ liked: true, disliked: false });
      }
    } else if (actionType === 'DISLIKE') {
      if (preferToggleState.disliked) {
        setPreferToggleState(prev => ({ ...prev, disliked: false }));
      } else {
        if (preferToggleState.liked) {
          setLikeCount(prev => prev - 1);
        }
        setPreferToggleState({ liked: false, disliked: true });
      }
    } else if (actionType === 'REPORT') {
      modalService.show(AdviseModal, { content: '신고되었습니다' });
    }
  };

  const { mutate } = useVideoAction(handleVideoActionSuccess);

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

  const handleRoportBtnClick = () => {
    const actionBody = {
      id,
      type: playType.current === 'video' ? 0 : 1,
      action: 'REPORT',
      uuid: userId,
    };
    mutate({
      type: 'post',
      actionBody,
    });
  };

  const handleShareBtnClick = async () => {
    await mediaService.copyUrl();
  };

  const handleProfilClickBtn = () => {
    if (playType.current === 'video') {
      navigate(`/channel/${videoData.uploaderUuid}`);
    } else if (playType.current === 'live') {
      navigate(`/channel/${videoData.hostUuid}`);
    }
  };

  const handleFriendReqSucces = data => {
    const { errorCode, message } = data;
    if (errorCode) {
      modalService.show(AdviseModal, { content: message });
    } else {
      modalService.show(AdviseModal, { content: '친구신청이 완료 되었습니다' });
    }
    setDisabled(true);
  };

  const { mutate: reqFriend } = useReqFriend(handleFriendReqSucces);

  const handleFriendReqBtnClick = () => {
    reqFriend(uploaderId);
  };

  if (!videoData) {
    return null;
  }

  return (
    <S.VideoMetaDataContainer>
      <S.VideoCategory type='caption'>#{videoData?.category}</S.VideoCategory>
      <S.VideoTitle type='component'>{videoData?.title}</S.VideoTitle>
      <S.VideoInfoContainer>
        <S.WatchPeople type='caption'>
          {playType.current === 'video' ? `조회수 ${videoData?.hits}회` : `${curUserCount}명`}
        </S.WatchPeople>
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
          <ActionButton onClick={handleShareBtnClick} element={<Share />} content='공유' />
          <ActionButton onClick={handleRoportBtnClick} element={<Report />} content='신고' />
        </S.ActionContainer>
      </S.VideoInfoContainer>
      <S.VideoSubInfoContainer>
        <S.MyProfile
          onClick={handleProfilClickBtn}
          size='md'
          imgSrc={`${process.env.REACT_APP_PROFILE_IMAGE}${
            playType.current === 'video' ? videoData?.uploaderUuid : videoData?.hostUuid
          }`}
        />
        <S.VideoSubInfo>
          <S.ChannelInfo>
            <S.ChannelName>
              {playType.current === 'video' ? videoData?.uploaderNickname : videoData?.hostNickname}
            </S.ChannelName>
            {playType.current === 'video' && (
              <S.SubscribePeople type='bottomTab'>{videoData?.subscriberCnt}명</S.SubscribePeople>
            )}
          </S.ChannelInfo>
          {videoData?.content && (
            <div>
              <S.ContentOverview isExpand={isOverviewExpand}>
                {videoData?.content}
              </S.ContentOverview>
              <S.ExpandContenOverviewBtn variant='text' onClick={handleExpandBtnClick}>
                {isOverviewExpand ? '간략히' : '더보기'}
              </S.ExpandContenOverviewBtn>
            </div>
          )}
        </S.VideoSubInfo>
        {uploaderId !== userId && (
          <S.SubScribeBtn size='sm' disabled={disabled} onClick={handleFriendReqBtnClick}>
            친구 신청
          </S.SubScribeBtn>
        )}
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
