import React from 'react';

import * as S from './HomePage.sytle';
import ThumbNailDummy from '@assets/image/ThumbNailDummy.jpg';

import { VideoOverview } from '@components/videos';

const dummyData = [
  {
    id: 1,
    thumbNailSrc: ThumbNailDummy,
    title: '마크툽(MAKTUB) X 마라는대로 - 찰나가 영원이 될 때 (The Eternal Moment) COVER',
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 2,
    thumbNailSrc: ThumbNailDummy,
    title: '[디지몬] 당신이 몰랐던 임프몬(베르제브몬)의 슬픈 이야기 (feat.레오몬)',
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 3,
    thumbNailSrc: ThumbNailDummy,
    title:
      '해리포터 가장 강력한 능력을 지닌 절대강자 Top 30 - 2부 + 영화 속 소름돋는 메세지와 해석',
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 4,
    thumbNailSrc: ThumbNailDummy,
    title: 'Harry Potter 20th Anniversary: Return to Hogwarts | Official Trailer | HBO Max',
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
  {
    id: 5,
    thumbNailSrc: ThumbNailDummy,
    title:
      'Harry Potter and the Deathly Hallows: Part 1 (4/5) Movie CLIP - Escape From Malfoy Manor (2010) HD',
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
  },
];

function HomePage() {
  return (
    <S.HomePageContainer>
      {dummyData.map(videoInfo => (
        <VideoOverview key={videoInfo.id} videoInfo={videoInfo} />
      ))}
    </S.HomePageContainer>
  );
}

export default HomePage;
