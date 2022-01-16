import styled from 'styled-components';

import { Typography, RealTimeMark } from '@components/cores';

export default {
  ViedeoOverviewContainer: styled.article`
    min-width: 210px;
    max-width: 400px;
  `,
  ThumbNailContainer: styled.div`
    position: relative;
  `,
  RealTimeIcon: styled(RealTimeMark)`
    position: absolute;
    bottom: 5px;
    right: 5px;
    width: auto;
  `,
  VideoInfoContainer: styled.div`
    display: flex;
    align-items: flex-start;
    margin-top: 12px;
  `,
  VideoInfo: styled.div`
    margin-left: 10px;
  `,
  VideoTitle: styled(Typography)`
    display: -webkit-box;
    -webkit-box-orient: vertical;
    max-height: 40px;
    -webkit-line-clamp: 2;
    overflow: hidden;
    text-overflow: ellipsis;
  `,
  VideoCaption: styled(Typography)`
    color: ${({ theme }) => theme.colors.placeHolder};
  `,
  VideoMetaContainer: styled.div`
    display: flex;
    & p:first-child:after {
      content: '';
      display: inline-block;
      width: 1px;
      height: 10px;
      margin: 0 3px;
      background-color: ${({ theme }) => theme.colors.placeHolder};
    }
  `,
};
