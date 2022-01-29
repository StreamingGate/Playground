import styled from 'styled-components';

import { Typography } from '@components/cores';
import { Avatar } from '@components/dataDisplays';
import { Button } from '@components/buttons';

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
  align-items: flex-start;
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
`;

export const ActionLabel = styled(Typography)``;

export const VideoSubInfoContainer = styled.div`
  display: flex;
  margin-top: 15px;
`;

export const MyProfile = styled(Avatar)`
  flex-shrink: 0;
  margin-right: 5px;
`;

export const VideoSubInfo = styled.div`
  display: flex;
  flex-direction: column;
  gap: 17px;
  flex-grow: 1;
`;

export const ChannelInfo = styled.div`
  display: flex;
  flex-direction: column;
`;

export const ChannelName = styled(Typography)``;

export const SubscribePeople = styled(Typography)`
  color: ${({ theme }) => theme.colors.customDarkGray};
`;

export const ContentOverview = styled(Typography)`
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
  overflow: hidden;
  text-overflow: ellipsis;
`;

export const SubScribeBtn = styled(Button)`
  flex-shrink: 0;
  padding: 5px 10px;
  height: fit-content;
`;
