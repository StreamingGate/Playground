import styled from 'styled-components';

import { Button } from '@components/buttons';

export const AcceptFriendModalContainer = styled.div``;

export const AcceptFriendModalTitle = styled.div`
  padding: 15px;
  border-bottom: 1px solid ${({ theme }) => theme.colors.separator};
`;

export const AcceptFriendModalBody = styled.div`
  margin-top: 20px;
`;

export const AcceptFriendList = styled.ul`
  height: 270px;
  overflow: auto;
`;

export const AcceptFriend = styled.li`
  display: flex;
  align-items: center;
  min-width: 350px;
  gap: 10px;
  padding: 0px 20px 0px;
  &:not(:last-child) {
    margin-bottom: 30px;
  }
`;

export const ActionContainer = styled.div`
  flex-grow: 1;
  text-align: right;
`;

export const AcceptButton = styled(Button)`
  margin-right: 10px;
`;

export const DeclineButton = styled(Button)`
  background-color: ${({ theme }) => theme.colors.background};
  color: ${({ theme }) => theme.colors.pgBlue};
`;

export const CloseButtonContainer = styled.div`
  margin: 20px;
`;

export const CloseButton = styled(Button)`
  width: 100%;
  background-color: ${({ theme }) => theme.colors.background};
  color: ${({ theme }) => theme.colors.pgBlue};
  font-size: ${({ theme }) => theme.fontSizes.subtitle};
`;
