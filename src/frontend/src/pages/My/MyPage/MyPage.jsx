import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

import * as S from './MyPage.style';
import ThumbNailDummy from '@assets/image/ThumbNailDummy.jpg';

import { Typography } from '@components/cores';
import { VideoOverview } from '@components/videos';

const dummyData = [
  {
    id: 1,
    thumbNailSrc: ThumbNailDummy,
    title:
      '[오래된정원] 6화 맛집 공덕동 맛집 포장해서 즐기기 (떡볶이 맛집, 코끼리분식, 마포원조떡볶이, 영광보쌈, 마포오향족발)',
    content: `최근 외모 바이러스라는 질병이 만연하는 대한민국에 사는 평범한 고등학교 1학년생인 박장미는 모든 게 다 보통이지만 딱 하나, 
    못생긴 외모가 콤플렉스인 소녀이다. 설상가상으로 출석번호가 나란해서 항상 달리기나 여러 체육활동을 같이하게 되는 아름다운 외모와 몸매의 소유자인 수진이와 자주 비교당해 괴롭기도 하고 짜증나기도 한다. 
    매일매일 되는 일은 없고 못생긴 외모는 항상 불만힌 장미는 어느 날 도둑고양이에게 싸구려시계를 도둑맞게 되고, 그 도둑고양이를 쫓아서 들어간 낡은 상가에서 따뜻하고 좋은 향기가 풍겨오는 한 이발소를 찾게 된다. 
    몰래 들여다 본 이발소에서 거지를 멋진 외모로 다듬어주는 거대한 가위를 가진 미용사와, 인간형으로 변신 가능한 고양이를 목격하고 제 눈을 믿지 못한 채로 장미는 집으로 돌아온다. 
    스스로도 그것이 현실이었나 싶을 정도로 현실성없는 경험이라 그냥 넘어갈 뻔 했으나, 
    학교에서 못생긴 외모 때문에 생겨난 '외모 바이러스'에 감염된 아이가 생기고 이를 고치려고 
    그 미용사가 고양이를 대동하고 나타나 아이를 고쳐놓고 간다. 장미는 그 미용사라면 외모 바이러스에 감염될까봐 고민하는 자신을 도와줄 수 있을까 싶어 그 미용실로 찾아가 예쁘게 바꿔달라고 부탁하다가 생각했던 것과는 다른 냉담한 반응에 낙담한다.`,
    userName: 'test',
    viewCount: 1,
    createdAt: '1시간 전',
    isRealTime: true,
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

function getMyPageTitle(type) {
  let title = '';
  if (type === 'history') {
    title = '시청한 동영상';
  } else if (type === 'like') {
    title = '좋아요 표시한 동영상';
  } else {
    title = '내 동영상';
  }

  return title;
}

function MyPage() {
  const navigate = useNavigate();
  const { type } = useParams();
  const [myPageTitle, setMyPageTitle] = useState('');

  useEffect(() => {
    if (!['history', 'like', 'library'].includes(type)) {
      navigate('/mypage/history');
    }
  }, []);

  useEffect(() => {
    setMyPageTitle(getMyPageTitle(type));
  }, [type]);

  return (
    <S.HistoryPageContainer>
      <Typography>{myPageTitle}</Typography>
      <S.MyVideoContainer>
        {dummyData.map(videoInfo => (
          <VideoOverview
            key={videoInfo.id}
            videoInfo={videoInfo}
            direction='horizontal'
            isLibrary={type === 'library'}
          />
        ))}
      </S.MyVideoContainer>
    </S.HistoryPageContainer>
  );
}

export default MyPage;
