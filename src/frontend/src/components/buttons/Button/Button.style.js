import styled, { css } from 'styled-components';

const getButtonPadding = size => {
  switch (size) {
    case 'lg':
      return css`
        padding: 10px 35px;
      `;
    case 'sm':
      return css`
        padding: 5px 10px;
      `;
    // default size is 'md'
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
    border-radius: 3px;
    cursor: pointer;
    ${({ size }) => getButtonPadding(size)}
    ${props => getButtonColor(props)}
    ${({ disabled }) =>
      disabled &&
      css`
        cursor: auto;
        opacity: 0.3;
      `}
    width: ${({ fullWidth }) => (fullWidth ? '100%' : 'auto')};
  `,
};
