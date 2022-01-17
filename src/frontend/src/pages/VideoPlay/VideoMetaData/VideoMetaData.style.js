import styled from 'styled-components';

import { Typography } from '@components/cores';

export const VideoMetaDataContainer = styled.div``;

export const VideoCategory = styled(Typography)`
  color: ${({ theme }) => theme.colors.pgBlue};
`;

export const VideoTitle = styled(Typography)`
  margin-bottom: 10px;
`;

export const VideoInfoContainer = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 10px;
  border-bottom: 1px solid ${({ theme }) => theme.colors.separator};
`;

export const WatchPeople = styled(Typography)`
  color: ${({ theme }) => theme.colors.customDarkGray};
`;

export const ActionContainer = styled.div`
  display: flex;
  gap: 30px;
`;

export const Action = styled.div`
  display: flex;
  align-items: center;
  gap: 9px;
`;

export const ActionLabel = styled(Typography)``;
