import styled from 'styled-components';

export const StudioPageContainer = styled.div`
  display: flex;
  gap: 20px;
  padding: 25px;
  min-width: 780px;
`;

export const PlayerConatiner = styled.div`
  background-color: #000000;
  position: relative;
  flex-grow: 1;
`;

export const StreamPlayer = styled.video`
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  height: 100%;
  aspect-ratio: 16 / 9;
`;

export const StreamControlContainer = styled.div`
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
  background-color: #676767;
  height: 50px;
`;

export const ChatRoomContainer = styled.div`
  height: 80vh;
`;
