import styled from 'styled-components';

import { Typography } from '@components/cores';
import { Button } from '@components/buttons';
import { Input } from '@components/forms';

export const FormStageInputContainer = styled.div`
  margin-bottom: 30px;
`;

export const InputLabel = styled(Typography)`
  color: ${({ theme }) => theme.colors.placeHolder};
  margin-bottom: 8px;
`;

export const StageInput = styled(Input)`
  position: relative;
  border: none;
  background-color: ${({ theme }) => theme.colors.background};
`;

// Stage 1
export const VerifyButtonContainer = styled.div`
  text-align: right;
`;

export const EmailVerifyInputContainer = styled.div`
  position: relative;
`;

export const Timer = styled(Typography)`
  position: absolute;
  top: 10px;
  right: 5px;
  color: ${({ theme }) => theme.colors.placeHolder};
`;

// Stage 2
export const ProfilInputContainer = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
`;

export const ProfilePreview = styled.img`
  width: 100px;
  height: 100px;
  border: none;
  border-radius: 50%;
  overflow: hidden;
  object-fit: cover;
`;

export const ProfileInput = styled(Input)`
  display: none;
`;

export const ProfileActionContainer = styled.div`
  display: flex;
  justify-content: center;
  gap: 5px;
`;

export const FileSelectBtn = styled(Button)``;

export const DefaultProfileBtn = styled(Button)`
  border-color: ${({ theme }) => theme.colors.separator};
`;

export const DefaultProfileBtnContent = styled(Typography)`
  color: ${({ theme }) => theme.colors.pgBlue};
`;
