import styled from 'styled-components';

export const CategorySliderContainer = styled.div`
  position: fixed;
  left: var(--side-nav-bar-width);
  right: var(--side-friend-list-width);
  z-index: 1;
  height: 60px;
  padding: 15px 0px;
  background-color: #ffffff;
  border-top: ${({ theme }) => `1px solid ${theme.colors.separator}`};
  border-bottom: ${({ theme }) => `1px solid ${theme.colors.separator}`};
`;
