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
    content: '';
    display: inline-block;
    width: 1px;
    height: 10px;
    margin: 0 3px;
    background-color: ${({ theme }) => theme.colors.placeHolder};
  }
`;

export const ViedeoOverviewContainer = styled.article`
  display: flex;
  flex-direction: ${({ direction }) => (direction === 'vertical' ? 'column' : 'row')};
  gap: 10px;
  max-width: ${({ direction }) => (direction === 'vertical' ? '400px' : 'none')};

  ${ThumbNailContainer} {
    ${({ direction }) =>
      direction === 'horizontal' &&
      css`
        max-width: 160px;
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
