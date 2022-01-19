import React, { useCallback, memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './VideoOverview.style';

import { Avatar } from '@components/dataDisplays';

function VideoOverview({ direction, isLibrary, videoInfo }) {
  const { thumbNailSrc, title, userName, content, viewCount, createdAt, isRealTime } = videoInfo;

  const renderVideoInfo = useCallback(() => {
    const NumberDataComponent = (
      <>
        <S.VideoCaption type='caption'>조회수 {viewCount}회</S.VideoCaption>
        <S.VideoCaption type='caption'>{createdAt}</S.VideoCaption>
      </>
    );

    if (direction === 'horizontal') {
      return (
        <>
          <S.VideoMetaContainer>
            {isLibrary ? (
              NumberDataComponent
            ) : (
              <>
                <S.VideoCaption type='caption'>{userName}</S.VideoCaption>
                <S.VideoCaption type='caption'>조회수 {viewCount}회</S.VideoCaption>
              </>
            )}
          </S.VideoMetaContainer>
          <S.VideoContent type='caption'>{content}</S.VideoContent>
        </>
      );
    }
    return (
      <>
        <S.VideoCaption type='caption'>{userName}</S.VideoCaption>
        <S.VideoMetaContainer>{NumberDataComponent}</S.VideoMetaContainer>
      </>
    );
  }, [direction]);

  return (
    <S.ViedeoOverviewContainer direction={direction}>
      <S.ThumbNailContainer>
        <img src={thumbNailSrc} alt='thumbnail' />
        {isRealTime && <S.RealTimeIcon />}
      </S.ThumbNailContainer>
      <S.VideoInfoContainer>
        {direction === 'vertical' && (
          <div>
            <Avatar size='xs' />
          </div>
        )}
        <S.VideoInfo>
          <S.VideoTitle type='highlightCaption'>{title}</S.VideoTitle>
          {renderVideoInfo()}
        </S.VideoInfo>
      </S.VideoInfoContainer>
    </S.ViedeoOverviewContainer>
  );
}

VideoOverview.propTypes = {
  direction: PropTypes.oneOf(['horizontal', 'vertical']),
  isLibrary: PropTypes.bool,
  videoInfo: PropTypes.shape({
    thumbNailSrc: PropTypes.string.isRequired,
    profileImgSrc: PropTypes.string,
    title: PropTypes.string.isRequired,
    userName: PropTypes.string.isRequired,
    viewCount: PropTypes.number.isRequired,
    content: PropTypes.string,
    createdAt: PropTypes.instanceOf(Date).isRequired,
    isRealTime: PropTypes.bool,
  }).isRequired,
};

VideoOverview.defaultProps = {
  direction: 'vertical',
  isLibrary: false,
};

export default memo(VideoOverview);
