import styled from 'styled-components';

import { Typography } from '@components/cores';

export const InputLabel = styled(Typography)`
  color: ${({ theme }) => theme.colors.placeHolder};
  margin-bottom: 8px;
`;

export const FormStageInputContainer = styled.div`
  margin-bottom: 30px;
`;

export const VerifyButtonContainer = styled.div`
  text-align: right;
`;
