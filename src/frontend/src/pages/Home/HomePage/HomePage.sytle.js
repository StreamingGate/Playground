import styled from 'styled-components';

export const HomePageContainer = styled.ul`
  display: grid;
  padding: 25px 25px 0px 25px;
  grid-template-columns: repeat(var(--video-num-in-a-row), 1fr);
  grid-gap: 22px;
`;
