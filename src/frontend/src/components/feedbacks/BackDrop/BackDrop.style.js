import styled, { css } from 'styled-components';

export default {
  BackDropContainer: styled.div`
    visibility: hidden;
    position: fixed;
    z-index: ${({ zIndex }) => zIndex};
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    opacity: 0;
    transition: opacity 225ms cubic-bezier(0.4, 0, 0.2, 1);

    ${({ isOpen }) =>
      isOpen &&
      css`
        visibility: visible;
        opacity: 0.6;
        background-color: ${({ theme }) => theme.colors.customDarkGray};
      `}
  `,
};
