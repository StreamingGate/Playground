import React, { Fragment } from 'react';
import { useParams } from 'react-router-dom';

import * as S from './ChannelPage.style';
import { useGetMyList } from '@utils/hook/query';

import ChannelMetaData from '../ChannelMetaData/ChannelMetaData';
import { VideoOverview } from '@components/videos';
import { Loading } from '@components/feedbacks';

function ChannelPage() {
  const { id } = useParams();

  const { data, isLoading } = useGetMyList('upload', id);

  return (
    <S.ChannelPageContainer>
      {isLoading && <Loading />}
      <ChannelMetaData />
      <S.ChannelVideoContainer>
        {data?.pages.map((group, i) => (
          <Fragment key={i}>
            {group.map(videoInfo => (
              <VideoOverview key={videoInfo.id} videoInfo={{ ...videoInfo, uploaderUuid: id }} />
            ))}
          </Fragment>
        ))}
      </S.ChannelVideoContainer>
    </S.ChannelPageContainer>
  );
}

export default ChannelPage;
