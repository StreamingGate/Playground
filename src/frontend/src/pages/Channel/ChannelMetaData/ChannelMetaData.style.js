import styled from 'styled-components';

import { Avatar } from '@components/dataDisplays';
import { Typography } from '@components/cores';
import { Button } from '@components/buttons';

export const ChannelMetaDataContainer = styled.div`
  display: flex;
  align-items: center;
`;

export const ChannelProfile = styled(Avatar)`
  margin-right: 15px;
`;

export const ChannelInfo = styled.div`
  display: flex;
  flex-direction: column;
  flex-grow: 1;
`;

export const ChannelName = styled(Typography)``;

export const ChannelNumberData = styled.div`
  display: flex;
  align-items: center;
`;

export const ChannelFriendNum = styled(Typography)`
  color: ${({ theme }) => theme.colors.customDarkGray};

  &:after {
    content: '';
    display: inline-block;
    width: 1px;
    height: 9px;
    margin: 0 3px;
    background-color: ${({ theme }) => theme.colors.customDarkGray};
  }
`;

export const ChannelVideoNum = styled(Typography)`
  color: ${({ theme }) => theme.colors.customDarkGray};
`;

export const SubscribeBtn = styled(Button)``;
