import styled from 'styled-components';

import { Button } from '@components/buttons';
import { Switch } from '@components/cores';

export const MobileStudioPageContainer = styled.div`
  position: relative;
  height: 100vh;
`;

export const MobileActionContainer = styled.div`
  display: flex;
  justify-content: space-between;
  position: absolute;
  z-index: 1;
  left: 0;
  right: 0;
  background-color: transparent;
`;

export const MobileStreamStopBtn = styled.a`
  padding: 8px;
  text-decoration: none;
  font-size: ${({ theme }) => theme.fontSizes.title};
  color: #ffffff;
`;

export const SwitchCameraIcon = styled(Switch)`
  /* width: 35px;
  height: 35px;
  min-width: 35px; */
`;

export const MobilePlayerContainer = styled.div`
  height: 100%;
  background-color: #000000;
`;

export const MobileStreamPlayer = styled.video`
  width: 100%;
  height: 100%;
  object-fit: cover;
`;
