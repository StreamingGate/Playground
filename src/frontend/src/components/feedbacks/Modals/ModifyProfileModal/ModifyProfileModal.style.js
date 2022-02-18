import styled from 'styled-components';

import { Typography, WhiteCamera } from '@components/cores';
import { Button } from '@components/buttons';
import { Input } from '@components/forms';

export const ModifyProfileModalContainer = styled.div``;

export const ModifyProfileModalTitle = styled.div`
  padding: 15px;
  border-bottom: 1px solid ${({ theme }) => theme.colors.separator};
`;

export const ModifyProfileModalBody = styled.div`
  padding: 30px 15px 15px 15px;
`;

export const UserProfileContainer = styled.div`
  display: flex;
  justify-content: center;
  cursor: pointer;
`;

export const UserProfile = styled.div`
  position: relative;
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background-color: #c4c4c4;
  overflow: hidden;
  background-color: #000000;
  opacity: 0.8;
`;

export const ProfileImage = styled.img`
  height: 100%;
  object-fit: cover;
`;

export const CameraIcon = styled(WhiteCamera)`
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 2;
`;

export const InputLabel = styled(Typography)`
  margin-top: 10px;
  color: ${({ theme }) => theme.colors.placeHolder};
`;

export const ProfileInput = styled(Input)`
  padding-left: 0;
`;

export const ActionContainer = styled.div`
  display: flex;
  margin-top: 60px;
  gap: 10px;
`;

export const CloseButton = styled(Button)`
  flex-grow: 1;
  background-color: ${({ theme }) => theme.colors.background};
  color: ${({ theme }) => theme.colors.pgBlue};
  font-size: ${({ theme }) => theme.colors.subtitle};
`;

export const ModifyButton = styled(Button)`
  flex-grow: 1;
  background-color: ${({ theme }) => theme.colors.pgBlue};
  font-size: ${({ theme }) => theme.colors.subtitle};
`;
