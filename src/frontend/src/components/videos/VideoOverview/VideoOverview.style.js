import styled, { css } from 'styled-components';

import { Typography, RealTimeMark } from '@components/cores';

const lineEllipsis = css`
  display: -webkit-box;
  -webkit-box-orient: vertical;
  max-height: 40px;
  -webkit-line-clamp: 2;
  overflow: hidden;
  text-overflow: ellipsis;
`;

export const ThumbNailContainer = styled.div`
  position: relative;
  z-index: -1;
  background-color: black;
  min-height: 200px;
`;

export const ThumbNail = styled.img`
  position: absolute;
  height: 100%;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
`;

export const RealTimeIcon = styled(RealTimeMark)`
  position: absolute;
  bottom: 5px;
  right: 5px;
  width: auto;
`;

export const VideoInfoContainer = styled.div`
  display: flex;
  align-items: flex-start;
`;

export const VideoInfo = styled.div`
  margin-left: 10px;
`;

export const VideoTitle = styled(Typography)`
  ${lineEllipsis}
`;

export const VideoCaption = styled(Typography)`
  ${lineEllipsis};
  -webkit-line-clamp: 1;
  color: ${({ theme }) => theme.colors.placeHolder};
`;

export const VideoContent = styled(VideoCaption)`
  -webkit-line-clamp: 2;
`;

export const VideoMetaContainer = styled.div`
  display: flex;

  & p:first-child:after {
    content: '•';
    display: inline-block;
    margin: 0 3px;
  }
`;

export const ViedeoOverviewContainer = styled.li`
  display: flex;
  flex-direction: ${({ direction }) => (direction === 'vertical' ? 'column' : 'row')};
  gap: 10px;
  max-width: ${({ direction }) => (direction === 'vertical' ? '450px' : 'none')};

  ${ThumbNailContainer} {
    ${({ direction }) =>
      direction === 'horizontal' &&
      css`
        max-width: 160px;
        height: 90px;
        flex-shrink 0;
      `}
  }

  ${VideoInfo} {
    ${({ direction }) =>
      direction === 'horizontal' &&
      css`
        display: flex;
        flex-direction: column;
        margin-left: 0;
      `}
  }
`;
