import styled, { css } from 'styled-components';

import { Avatar } from '@components/dataDisplays';
import { Typography } from '@components/cores';

export const ChatDialogContainer = styled.li`
  display: flex;
  align-items: flex-start;

  /* remove!! */
  max-width: 640px;
`;

export const ChatMetaContainer = styled.div`
  display: flex;
  align-items: center;
  flex-shrink: 0;
`;

export const ChatProfile = styled(Avatar)`
  margin-right: 4.92px;

  ${({ isAdmin }) =>
    isAdmin &&
    css`
      border: 2px solid ${({ theme }) => theme.colors.pgOrange};
    `}
`;

export const TimeStamp = styled(Typography)`
  margin-right: 9.83px;
`;

export const UserName = styled(Typography)`
  margin-right: 14.75px;
  color: ${({ theme }) => theme.colors.customDarkGray};
`;

export const Message = styled(Typography)`
  padding-top: 7px;
  word-break: break-word;
`;
