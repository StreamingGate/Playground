import styled, { css } from 'styled-components';

export const ChipButton = styled.button`
  background-color: ${({ theme }) => theme.colors.background};
  color: ${({ theme }) => theme.colors.customDarkGray};
  border: ${({ theme }) => `1px solid ${theme.colors.separator}`};
  border-radius: 15px;
  font-size: ${({ theme }) => theme.fontSizes.component};
  padding: 1px 10px;

  ${({ isSelected }) =>
    isSelected &&
    css`
      background-color: ${({ theme }) => theme.colors.studioBlack};
      color: #ffffff;
      border: none;
    `}
  cursor: pointer;
`;
