import React from 'react';
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
          <S.ContentOverview>
            한 달 후, 천 년 만에 찾아온다는 혜성을 기다리고 있는 일본. 산골 깊은 시골 마을에 살고
            있는 여고생 미츠하는 우울한 나날을 보내고 있다. 촌장인 아버지의 선거활동과 신사 집안의
            낡은 풍습. 좁고 작은 마을에서는 주위의 시선이 너무나도 신경 쓰이는 나이인 만큼 도시를
            향한 동경심은 커지기만 한다.
          </S.ContentOverview>
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
