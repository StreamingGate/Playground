import React, { useCallback, memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './VideoOverview.style';

import { Avatar } from '@components/dataDisplays';

function VideoOverview({ direction, isLibrary, videoInfo, isLive }) {
  const { thumbnail, title, uploaderNickname, content, hits, createdAt } = videoInfo;

  const renderVideoInfo = useCallback(() => {
    const NumberDataComponent = (
      <>
        <S.VideoCaption type='caption'>조회수 {hits}회</S.VideoCaption>
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
                <S.VideoCaption type='caption'>{uploaderNickname}</S.VideoCaption>
                <S.VideoCaption type='caption'>조회수 {hits}회</S.VideoCaption>
              </>
            )}
          </S.VideoMetaContainer>
          <S.VideoContent type='caption'>{content}</S.VideoContent>
        </>
      );
    }
    return (
      <>
        <S.VideoCaption type='caption'>{uploaderNickname}</S.VideoCaption>
        <S.VideoMetaContainer>{NumberDataComponent}</S.VideoMetaContainer>
      </>
    );
  }, [direction]);

  return (
    <S.ViedeoOverviewContainer direction={direction}>
      <S.ThumbNailContainer>
        <img src={thumbnail} alt='thumbnail' />
        {isLive && <S.RealTimeIcon />}
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
  isLive: PropTypes.bool,
  videoInfo: PropTypes.shape({
    thumbnail: PropTypes.string.isRequired,
    profileImgSrc: PropTypes.string,
    title: PropTypes.string.isRequired,
    uploaderNickname: PropTypes.string.isRequired,
    hits: PropTypes.number.isRequired,
    content: PropTypes.string,
    createdAt: PropTypes.instanceOf(Date).isRequired,
  }).isRequired,
};

VideoOverview.defaultProps = {
  direction: 'vertical',
  isLibrary: false,
  isLive: false,
};

export default memo(VideoOverview);
