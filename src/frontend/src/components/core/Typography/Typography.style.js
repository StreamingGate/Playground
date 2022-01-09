import styled from 'styled-components';

export default {
  P: styled.p`
    font-size: ${props => props.theme.fontSizes[props.type]};
    font-weight: ${props => props.theme.fontWeights[props.type]};
  `,
};
