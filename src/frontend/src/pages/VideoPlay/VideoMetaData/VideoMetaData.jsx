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

function VideoMetaData() {
  const [isOverviewExpand, setOverviewExpand] = useState(false);

  const handleExpandBtnClick = () => {
    setOverviewExpand(prev => !prev);
  };

  return (
    <S.VideoMetaDataContainer>
      <S.VideoCategory type='caption'>#음악</S.VideoCategory>
      <S.VideoTitle type='component'>실시간 스트리밍 제목</S.VideoTitle>
      <S.VideoInfoContainer>
        <S.WatchPeople type='caption'>6702명 시청 중</S.WatchPeople>
        <S.ActionContainer>
          <ActionButton element={<ThumbUp />} content='8.5명' />
          <ActionButton element={<ThumbDown />} content='싫어요' />
          <ActionButton element={<Share />} content='공유' />
          <ActionButton element={<Report />} content='신고' />
        </S.ActionContainer>
      </S.VideoInfoContainer>
      <S.VideoSubInfoContainer>
        <S.MyProfile size='md' />
        <S.VideoSubInfo>
          <S.ChannelInfo>
            <S.ChannelName>채널 이름</S.ChannelName>
            <S.SubscribePeople type='bottomTab'>2.01천 명</S.SubscribePeople>
          </S.ChannelInfo>
          <div>
            <S.ContentOverview isExpand={isOverviewExpand}>
              때는 1920년대, 당시 유럽은 그린델왈드의 득세로 혼란스러운 시기였다. 영화가
              시작하자마자 한밤중에 오러 5명이 루모스 마법을 사용해 어느 한 대저택에 조심조심
              접근하는데 갑자기 대문이 열리더니 초록색 불빛과 함께 오러 5명은 순식간에 충격파로 죽게
              된다. 이후 그들의 시체 앞에 그린델왈드의 뒷모습이 나타나며 영화 시작. 그 후에는
              그린델왈드 관련 소식과 각 나라마다의 대처 등의 이슈를 담은 신문기사들이 해리 포터
              5편처럼 빠르게 지나간다. 그런데 어느 순간 그린델왈드가 유럽에서 자취를 감추게 된다.
            </S.ContentOverview>
            <S.ExpandContenOverviewBtn variant='text' onClick={handleExpandBtnClick}>
              더보기
            </S.ExpandContenOverviewBtn>
          </div>
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
