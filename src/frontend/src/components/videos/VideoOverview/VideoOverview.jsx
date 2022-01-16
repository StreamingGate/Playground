import React, { memo } from 'react';
import PropTypes from 'prop-types';

import S from './VideoOverview.style';
// import RealTimeMark from '@assets/image/RealTimeMark.png';

import { Avatar } from '@components/dataDisplays';

function VideoOverview({
  direction,
  thumbNailSrc,
  profileImgSrc,
  title,
  userName,
  viewCount,
  createdAt,
  isRealTime,
}) {
  return (
    <S.ViedeoOverviewContainer direction={direction}>
      <S.ThumbNailContainer>
        <img src={thumbNailSrc} alt='thumbnail' />
        {isRealTime && <S.RealTimeIcon />}
      </S.ThumbNailContainer>
      <S.VideoInfoContainer>
        <div>
          <Avatar size='small' />
        </div>
        <S.VideoInfo>
          <S.VideoTitle type='highlightCaption'>{title}</S.VideoTitle>
          <S.VideoCaption type='caption'>{userName}</S.VideoCaption>
          <S.VideoMetaContainer>
            <S.VideoCaption type='caption'>조회 수 {viewCount}회</S.VideoCaption>
            <S.VideoCaption type='caption'>{createdAt}</S.VideoCaption>
          </S.VideoMetaContainer>
        </S.VideoInfo>
      </S.VideoInfoContainer>
    </S.ViedeoOverviewContainer>
  );
}

VideoOverview.propTypes = {
  direction: PropTypes.oneOf(['horizontal', 'vertical']),
  thumbNailSrc: PropTypes.string.isRequired,
  profileImgSrc: PropTypes.string,
  title: PropTypes.string.isRequired,
  userName: PropTypes.string.isRequired,
  viewCount: PropTypes.number.isRequired,
  createdAt: PropTypes.instanceOf(Date).isRequired,
  isRealTime: PropTypes.bool,
};

VideoOverview.defaultProps = {
  direction: 'vertical',
  profileImgSrc: '',
  isRealTime: false,
};

export default memo(VideoOverview);
