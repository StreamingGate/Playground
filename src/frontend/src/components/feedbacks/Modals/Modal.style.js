import styled from 'styled-components';

import { Button } from '@components/buttons';

export const AdviseModalContainer = styled.div`
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-height: 120px;
  padding: 20px;
`;

export const AdviseModalContent = styled.div`
  text-align: center;
`;

export const AdviseModalAction = styled.div`
  display: flex;
  justify-content: space-around;
  text-align: ${({ position }) => position};
`;

export const CancelButton = styled(Button)`
  margin-left: -18px;
`;
