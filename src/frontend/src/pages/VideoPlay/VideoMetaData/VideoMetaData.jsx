import React from 'react';

import * as S from './VideoMetaData.style';

import { IconButton } from '@components/buttons';
import { ThumbUp, ThumbDown, Share, Report } from '@components/cores';

function VideoMetaData() {
  return (
    <S.VideoMetaDataContainer>
      <S.VideoCategory type='caption'>#음악</S.VideoCategory>
      <S.VideoTitle type='component'>실시간 스트리밍 제목</S.VideoTitle>
      <S.VideoInfoContainer>
        <S.WatchPeople type='caption'>6702명 시청 중</S.WatchPeople>
        <S.ActionContainer>
          <S.Action>
            <IconButton>
              <ThumbUp />
            </IconButton>
            <S.ActionLabel type='caption'>8.5회</S.ActionLabel>
          </S.Action>
          <S.Action>
            <IconButton>
              <ThumbDown />
            </IconButton>
            <S.ActionLabel type='caption'>싫어요</S.ActionLabel>
          </S.Action>
          <S.Action>
            <IconButton>
              <Share />
            </IconButton>
            <S.ActionLabel type='caption'>공유</S.ActionLabel>
          </S.Action>
          <S.Action>
            <IconButton>
              <Report />
            </IconButton>
            <S.ActionLabel type='caption'>신고</S.ActionLabel>
          </S.Action>
        </S.ActionContainer>
      </S.VideoInfoContainer>
    </S.VideoMetaDataContainer>
  );
}

export default VideoMetaData;
