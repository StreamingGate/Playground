import styled, { css } from 'styled-components';

import { Typography } from '@components/cores';

const stepperTransition = css`
  transition: background-color 200ms cubic-bezier(0.4, 0, 0.2, 1);
`;

export const StepperContainer = styled.ol`
  display: flex;
  flex-wrap: wrap;
  --size: ${({ width }) => width};
  --spacing: ${({ spacing }) => spacing};
  --active-step-color: ${({ activeColor }) => activeColor};
  --inactive-step-color: ${({ inActiveColor }) => inActiveColor};
`;

export const StepContent = styled(Typography)`
  display: flex;
  justify-content: center;
  align-items: center;
  width: var(--size);
  height: var(--size);
  margin: 0 auto;
  border-radius: 100%;
  ${stepperTransition};
  background-color: var(--inactive-step-color);
  color: white;
`;

export const Step = styled.li`
  flex: 1;

  &:not(:first-child):before {
    content: '';
    display: block;
    width: calc(100% - var(--size) - calc(2 * var(--spacing)));
    height: 2px;
    position: relative;
    top: 50%;
    right: calc(50% - calc(var(--size) / 2) - var(--spacing));
    ${stepperTransition};
    background-color: ${({ isActive }) =>
      isActive ? css`var(--active-step-color)` : css`var(--inactive-step-color)`};
  }

  ${StepContent} {
    ${({ isActive }) =>
      isActive &&
      css`
        background-color: ${({ theme }) => theme.colors.pgBlue};
      `}
  }
`;
