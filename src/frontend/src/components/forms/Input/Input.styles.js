import styled, { css } from 'styled-components';

const getInputPadding = size => {
  switch (size) {
    case 'large':
      return css`
        padding: 14px 15px;
      `;
    //   default size is 'small'
    default:
      return css`
        padding: 10px;
      `;
  }
};

const getInputBorder = props => {
  const { variant, theme } = props;
  switch (variant) {
    case 'standard':
      return css`
        border: none;
        border-bottom: 2px solid ${theme.colors.placeHolder};

        &:focus {
          border-bottom-color: ${theme.colors.youtubeBlue};
        }
      `;
    // default variant is 'outlined
    default:
      return css`
        border-radius: 3px;
      `;
  }
};

const getInputOutline = props => {
  const { variant, theme } = props;
  switch (variant) {
    case 'standard':
      return css`
        outline: none;
      `;
    // default variant is 'outlined'
    default:
      return css`
        outline-color: ${theme.colors.youtubeBlue};
      `;
  }
};

export default {
  Input: styled.input`
    font-size: ${props => props.theme.fontSizes[props.fontSize]};
    border: 1px solid ${({ theme }) => theme.colors.placeHolder};
    width: ${({ fullWidth }) => (fullWidth ? '100%' : 'auto')};
    ${({ size }) => getInputPadding(size)};
    ${props => getInputBorder(props)};
    ${props => getInputOutline(props)}

    &::placeholder {
      color: ${({ theme }) => theme.colors.placeHolder};
    }
  `,
};
