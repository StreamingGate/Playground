import styled, { css } from 'styled-components';

import { breakPoint } from '@utils/constant';

import { Button } from '@components/buttons';
import { VerticalLogo, Typography } from '@components/cores';

const { queries, screenSize } = breakPoint;

export const RegisterPageContainer = styled.main`
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 675px;
  min-width: ${() =>
    css`
      ${screenSize.minSize}px
    `};
  height: 100vh;
  margin: 0 auto;
`;

export const RegisterFormContainer = styled.div`
  padding: 43px 0;
  background-color: #ffffff;

  @media (${queries.mobileMax}) {
    height: 100%;
  }
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

export const FormHorizontalLogo = styled(VerticalLogo)`
  width: 135px;
  height: 28px;
  margin-right: 8px;
`;

export const RegisterTitle = styled(Typography)``;

export const StageContainer = styled.div`
  margin-top: 45px;
`;

export const FormActionContainer = styled.div`
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-top: auto;
`;

export const PrevButton = styled(Button)`
  border-color: ${({ theme }) => theme.colors.separator};
  padding: 12px 39px;
`;

export const PrevBtnContent = styled(Typography)`
  color: ${({ theme }) => theme.colors.pgBlue};
`;

export const NextButton = styled(Button)`
  padding: 12px 75px;
`;

export const NextBtnContent = styled(Typography)``;
