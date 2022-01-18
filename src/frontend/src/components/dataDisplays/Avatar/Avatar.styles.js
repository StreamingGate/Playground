import styled, { css } from 'styled-components';

const getAvatarSize = size => {
  switch (size) {
    case 'xl':
      return css`
        width: 80px;
        height: 80px;
      `;
    case 'lg':
      return css`
        width: 50px;
        height: 50px;
      `;
    case 'md':
      return css`
        width: 35px;
        height: 35px;
      `;
    case 'xs':
      return css`
        width: 20px;
        height: 20px;
      `;
    //   default size is 'sm'
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
