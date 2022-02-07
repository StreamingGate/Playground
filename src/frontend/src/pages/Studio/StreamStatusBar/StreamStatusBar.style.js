import styled from 'styled-components';

import { Typography } from '@components/cores';

export const StreamStatusBarContainer = styled.div`
  display: flex;
  gap: 35px;
  padding: 20px 0px 7px 20px;
`;

export const TimerContainer = styled.div`
  display: flex;
  border-radius: 5px;
  overflow: hidden;
`;

export const TimerTitle = styled(Typography)`
  padding: 5px 8px;
  background-color: ${({ theme }) => theme.colors.pgBlue};
  color: #ffffff;
`;

export const Timer = styled(Typography)`
  padding: 5px 8px;
  background-color: ${({ theme }) => theme.colors.studioBlack};
  color: #ffffff;
`;

export const ViewerCountContainer = styled.div`
  display: flex;
  align-items: center;
`;

export const ViewerCount = styled(Typography)`
  margin-left: 5px;
  color: #ffffff;
`;

export const LikeCountContaienr = styled.div`
  display: flex;
  align-items: center;
`;

export const LikeCount = styled(Typography)`
  margin-left: 5px;
  color: #ffffff;
`;
