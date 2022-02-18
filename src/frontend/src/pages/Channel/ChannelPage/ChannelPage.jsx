import React, { Fragment } from 'react';
import { useParams } from 'react-router-dom';

import * as S from './ChannelPage.style';
import { useGetMyList } from '@utils/hook/query';

import ChannelMetaData from '../ChannelMetaData/ChannelMetaData';
import { VideoOverview } from '@components/videos';

function ChannelPage() {
  const { id } = useParams();

  const { data } = useGetMyList('upload', id);

  return (
    <S.ChannelPageContainer>
      <ChannelMetaData />
      <S.ChannelVideoContainer>
        {data?.pages.map((group, i) => (
          <Fragment key={i}>
            {group.map(videoInfo => (
              <VideoOverview key={videoInfo.id} videoInfo={videoInfo} />
            ))}
          </Fragment>
        ))}
      </S.ChannelVideoContainer>
    </S.ChannelPageContainer>
  );
}

export default ChannelPage;
