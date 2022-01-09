import styled, { css } from 'styled-components';

const getButtonPadding = size => {
  switch (size) {
    case 'large':
      return css`
        padding: 10px 35px;
      `;
    // default size is 'small'
    default:
      return css`
        padding: 5px 18px;
      `;
  }
};

const getButtonColor = props => {
  const { variant, theme, color } = props;
  switch (variant) {
    case 'outlined':
      return css`
        background-color: 'transparent';
        color: ${theme.colors[color]};
        border: 1px solid ${theme.colors[color]};
      `;
    // default variant is 'contained'
    default:
      return css`
        background-color: ${theme.colors[color]};
        color: #ffffff;
        border: none;
      `;
  }
};

export default {
  B: styled.button`
    ${({ size }) => getButtonPadding(size)}
    ${props => getButtonColor(props)}
    border-radius: 3px;
    cursor: pointer;
  `,
};
