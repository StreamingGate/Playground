import React from 'react';

import * as S from './ChannelPage.style';
import ThumbNailDummy from '@assets/image/ThumbNailDummy.jpg';

import ChannelMetaData from '../ChannelMetaData/ChannelMetaData';
import { VideoOverview } from '@components/videos';

const dummyData = [
  {
    id: 1,
    thumbNailSrc: ThumbNailDummy,
    title:
      '[오래된정원] 6화 맛집 공덕동 맛집 포장해서 즐기기 (떡볶이 맛집, 코끼리분식, 마포원조떡볶이, 영광보쌈, 마포오향족발)',
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 2,
    thumbNailSrc: ThumbNailDummy,
    title: 'KTX vs 홍보맨, 누가 더 빠를까?ㅣ국내 최초 200m 달리기 대결',
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 3,
    thumbNailSrc: ThumbNailDummy,
    title: `ST워너비 '아리랑' Official MV (원곡 : SG워너비)`,
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 4,
    thumbNailSrc: ThumbNailDummy,
    title:
      '[EN] 국대등장 세계랭킹1위와 붙어버렸습니다🤼 | 태권도 | 이대훈 | 국가대표 | 워크맨 ep.134',
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 5,
    thumbNailSrc: ThumbNailDummy,
    title: 'After all this time? Always.',
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 6,
    thumbNailSrc: ThumbNailDummy,
    title: `Harry Potter and the Deathly Hallows part 2 - Snape's memories part 2 (HD)`,
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 7,
    thumbNailSrc: ThumbNailDummy,
    title: `After All This Time? (Snape's Story) | Learn English With Harry Potter`,
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 8,
    thumbNailSrc: ThumbNailDummy,
    title: `Harry Potter and the Deathly Hallows part 2 - Snape's memories part 2 (HD)`,
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 9,
    thumbNailSrc: ThumbNailDummy,
    title: `Harry Potter and the Deathly Hallows part 2 - Snape's memories part 2 (HD)`,
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 10,
    thumbNailSrc: ThumbNailDummy,
    title: `Harry Potter and the Deathly Hallows part 2 - Snape's memories part 2 (HD)`,
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 11,
    thumbNailSrc: ThumbNailDummy,
    title: `Harry Potter and the Deathly Hallows part 2 - Snape's memories part 2 (HD)`,
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
];

function ChannelPage() {
  return (
    <S.ChannelPageContainer>
      <ChannelMetaData />
      <S.ChannelVideoContainer>
        {dummyData.map(videoInfo => (
          <VideoOverview key={videoInfo.id} videoInfo={videoInfo} />
        ))}
      </S.ChannelVideoContainer>
    </S.ChannelPageContainer>
  );
}

export default ChannelPage;
