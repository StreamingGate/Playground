import styled from 'styled-components';

import { Button } from '@components/buttons';
import { VerticalLogo, Typography } from '@components/cores';

export const RegisterPageContainer = styled.main`
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 675px;
  height: 100vh;
  margin: 0 auto;
`;

export const RegisterFormContainer = styled.div`
  padding: 43px 0;
  background-color: #ffffff;
`;

export const RegisterForm = styled.form`
  display: flex;
  flex-direction: column;
  max-width: fit-content;
  min-height: 470px;
  margin: 0 auto;
`;

export const RegisterTitleContainer = styled.header`
  display: flex;
  margin-bottom: 40px;
`;

export const RegisterTitle = styled(Typography)``;

export const FormHorizontalLogo = styled(VerticalLogo)`
  width: 135px;
  height: 28px;
  margin-right: 8px;
`;

export const FormControlBtnContainer = styled.div`
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-top: auto;
`;

export const PrevButton = styled(Button)`
  border-color: ${({ theme }) => theme.colors.separator};
  padding: 12px 39px;
`;

export const PrevBtnCaption = styled(Typography)`
  color: ${({ theme }) => theme.colors.pgBlue};
`;

export const NextButton = styled(Button)`
  padding: 12px 75px;
`;

export const NextBtnCaption = styled(Typography)``;
