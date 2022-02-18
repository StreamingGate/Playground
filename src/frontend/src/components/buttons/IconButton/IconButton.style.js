import styled, { css } from 'styled-components';

const getIconButtonPadding = size => {
  switch (size) {
    case 'large':
      return css`
        padding: 16px;
      `;
    default:
      return css`
        padding: 8px;
      `;
  }
};

export default {
  Button: styled.button`
    ${({ size }) => getIconButtonPadding(size)}
    border-radius: 100%;
    cursor: pointer;
    transition: background-color 150ms cubic-cubic-bezier(0.4, 0, 0.2, 1) 0ms;
    &:hover {
      background-color: rgba(0, 0, 0, 0.04);
    }
  `,
};
