import styled from 'styled-components';

export const ChannelPageContainer = styled.div`
  margin: 25px 25px 0px 25px;
`;

export const ChannelVideoContainer = styled.div`
  display: grid;
  margin-top: 40px;
  grid-template-columns: repeat(var(--video-num-in-a-row), 1fr);
  grid-gap: 22px;
`;
