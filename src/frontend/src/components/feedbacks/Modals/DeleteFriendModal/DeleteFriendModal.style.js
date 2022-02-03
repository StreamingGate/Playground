import styled from 'styled-components';

import { Button } from '@components/buttons';

export const DeleteFriendModalContainer = styled.div``;

export const DeleteFriendModalTitle = styled.div`
  padding: 15px;
  border-bottom: 1px solid ${({ theme }) => theme.colors.separator};
`;

export const DeleteFriendModalBody = styled.div`
  padding: 30px 15px 15px;
`;

export const DeleteFriendInfoContainer = styled.div`
  display: flex;
  gap: 10px;
  align-items: center;
  justify-content: center;
  margin-bottom: 30px;
`;

export const ActionContainer = styled.div`
  display: flex;
  margin-top: 40px;
  gap: 10px;
`;

export const CloseButton = styled(Button)`
  flex-grow: 1;
  background-color: ${({ theme }) => theme.colors.background};
  color: ${({ theme }) => theme.colors.pgBlue};
  font-size: ${({ theme }) => theme.fontSizes.subtitle};
`;

export const DeleteButton = styled(Button)`
  flex-grow: 1;
  font-size: ${({ theme }) => theme.fontSizes.subtitle};
`;
