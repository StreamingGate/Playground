import React, { useEffect, useState, useCallback, memo } from 'react';
import { useNavigate } from 'react-router-dom';
import PropTypes from 'prop-types';

import * as S from './VideoOverview.style';
import { timeService } from '@utils/service';

import { Avatar } from '@components/dataDisplays';

function VideoOverview({ direction, isLibrary, videoInfo, isLive }) {
  const {
    id,
    thumbnail,
    title,
    uploaderNickname,
    hostNickname,
    content,
    hits,
    createdAt,
    uuid,
    hostUuid,
    uploaderUuid,
  } = videoInfo;
  const navigate = useNavigate();

  const [userName, setUserName] = useState('');
  useEffect(() => {
    setUserName(uploaderNickname || hostNickname);
  }, [uploaderNickname, hostNickname]);

  const renderVideoInfo = useCallback(() => {
    const NumberDataComponent = (
      <>
        <S.VideoCaption type='caption'>조회수 {hits}회</S.VideoCaption>
        <S.VideoCaption type='caption'>
          {timeService.processVideoUploadTime(createdAt)}
        </S.VideoCaption>
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
                <S.VideoCaption type='caption'>조회수 {hits}회</S.VideoCaption>
              </>
            )}
          </S.VideoMetaContainer>
          <S.VideoContent type='caption'>{content}</S.VideoContent>
        </>
      );
    }
    return !isLive ? (
      <>
        <S.VideoCaption type='caption'>{userName}</S.VideoCaption>
        <S.VideoMetaContainer>{NumberDataComponent}</S.VideoMetaContainer>
      </>
    ) : (
      <S.VideoMetaContainer>
        <S.VideoCaption type='caption'>{userName}</S.VideoCaption>
        <S.VideoCaption type='caption'>
          {timeService.processVideoUploadTime(createdAt)}
        </S.VideoCaption>
      </S.VideoMetaContainer>
    );
  }, [direction, userName]);

  const handleVideoClick = () => {
    const path = uploaderNickname ? `/video-play/${id}` : `/live-play/${id}`;
    navigate(path);
  };

  const handleProfileClick = e => {
    e.stopPropagation();
    if (hostNickname) {
      navigate(`/channel/${hostUuid}`);
    }
    if (uploaderNickname) {
      navigate(`/channel/${uploaderUuid}`);
    }
  };

  return (
    <S.ViedeoOverviewContainer direction={direction} onClick={handleVideoClick}>
      <S.ThumbNailContainer>
        <S.ThumbNail
          loading='lazy'
          src={isLive ? `https://d8knntbqcc7jf.cloudfront.net/thumbnail/${uuid}` : thumbnail}
          alt='thumbnail'
        />
        {isLive && <S.RealTimeIcon />}
      </S.ThumbNailContainer>
      <S.VideoInfoContainer>
        {direction === 'vertical' && (
          <div>
            <Avatar
              size='xs'
              imgSrc={
                isLive
                  ? `${process.env.REACT_APP_PROFILE_IMAGE}${hostUuid}`
                  : `${process.env.REACT_APP_PROFILE_IMAGE}${uploaderUuid}`
              }
              onClick={handleProfileClick}
            />
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
    uploaderNickname: PropTypes.string,
    hostNickname: PropTypes.string,
    hits: PropTypes.number,
    content: PropTypes.string,
    createdAt: PropTypes.string,
  }).isRequired,
};

VideoOverview.defaultProps = {
  direction: 'vertical',
  isLibrary: false,
  isLive: false,
};

export default memo(VideoOverview);
