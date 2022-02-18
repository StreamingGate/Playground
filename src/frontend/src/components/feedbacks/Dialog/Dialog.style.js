import styled, { css } from 'styled-components';

const getDialogMaxWidth = size => {
  switch (size) {
    case 'md':
      return css`
        max-width: 900px;
      `;
    case 'lg':
      return css`
        max-width: 1200px;
      `;
    case 'xl':
      return css`
        max-width: 1536px;
      `;
    default:
      return css`
        max-width: 600px;
      `;
  }
};

export const DialogContainer = styled.div`
  display: ${({ isOpen }) => (isOpen ? 'flex' : 'none')};
  position: fixed;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  height: 100vh;
  justify-content: center;
  align-items: center;
  z-index: ${({ zIndex }) => zIndex};
`;

export const DialogContent = styled.div`
  background-color: #ffffff;
  border-radius: 5px;
  ${({ maxWidth }) => getDialogMaxWidth(maxWidth)}
  min-width: 300px;
  overflow: hidden;
`;
