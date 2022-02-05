import styled from 'styled-components';

export const Select = styled.select`
  padding: 10px;
  border: 1px solid ${({ theme }) => theme.colors.placeHolder};
  border-radius: 3px;
`;
