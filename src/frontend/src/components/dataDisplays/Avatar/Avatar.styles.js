import styled, { css } from 'styled-components';

const getAvatarSize = size => {
  switch (size) {
    case 'exLarge':
      return css`
        width: 50px;
        height: 50px;
      `;
    case 'large':
      return css`
        width: 35px;
        height: 35px;
      `;
    case 'small':
      return css`
        width: 20px;
        height: 20px;
      `;
    //   default size is 'medium'
    default:
      return css`
        width: 29px;
        height: 29px;
      `;
  }
};

export default {
  AvartarContainer: styled.div`
    ${({ size }) => getAvatarSize(size)}
    border-radius: 100%;
    overflow: hidden;
    cursor: pointer;
  `,
};
