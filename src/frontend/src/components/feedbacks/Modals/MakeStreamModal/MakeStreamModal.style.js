import styled, { css } from 'styled-components';

import { Typography, Camera, Video } from '@components/cores';
import { Button } from '@components/buttons';
import { Input, Select } from '@components/forms';

const videoInputCommonStyle = css`
  background-color: transparent;
  color: #ffffff;
`;

export const InputContainer = styled.div`
  text-align: right;
`;

export const InputCount = styled(Typography)`
  color: ${({ isLimit, theme }) => (isLimit ? 'red' : theme.colors.placeHolder)};
`;

export const MakeStreamModalContainer = styled.div`
  background-color: #444444;
`;

export const StreamModalTitleContainer = styled.div`
  padding: 15px 20px;
  border-bottom: 1px solid ${({ theme }) => theme.colors.customDarkGray};
`;

export const StreamModalTitle = styled(Typography)`
  color: #ffffff;
`;

export const StreamModalBody = styled.form`
  padding: 30px 50px 20px;
  min-width: 850px;
`;

export const StreamInfoContainer = styled.div`
  display: flex;
`;

export const VideoSelectContainer = styled.div`
  margin-right: 20px;
`;

export const InputLabel = styled(Typography)`
  margin-bottom: 5px;
  color: ${({ theme }) => theme.colors.background};
`;

export const VideoPreviewContainer = styled.div`
  position: relative;
`;

export const VideoPreview = styled.video`
  width: 270px;
  height: 150px;
  border: 1px solid ${({ theme }) => theme.colors.placeHolder};
  border-radius: 3px;
  overflow: hidden;
`;

export const VideoIcon = styled(Video)`
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
`;

export const VideoFileInput = styled(Input)`
  display: none;
`;

export const VideoDetailInfoContainer = styled.div`
  flex-grow: 1;
`;

export const VideoTitleInput = styled(Input)`
  ${videoInputCommonStyle}
`;

export const VideoContentInput = styled(Input)`
  ${videoInputCommonStyle}
`;

export const CategorySelectContainer = styled.div`
  margin-top: 30px;
`;

export const CategorySelect = styled(Select)`
  background-color: transparent;
  color: ${({ theme }) => theme.colors.placeHolder};
`;

export const ThumbnailSelectContainer = styled.div`
  margin-top: 30px;
`;

export const InputSubLabel = styled(Typography)`
  margin-bottom: 10px;
  color: ${({ theme }) => theme.colors.placeHolder};
`;

export const ThumbnailPreviewContainer = styled.div``;

export const ThumbnailPreview = styled.div`
  position: relative;
  width: 140px;
  height: 90px;
  border: 1px solid ${({ theme }) => theme.colors.placeHolder};
  border-radius: 3px;
  overflow: hidden;
  cursor: pointer;
  background-image: ${({ src }) => src && `url(${src})`};
  background-size: cover;
`;

export const CameraIcon = styled(Camera)`
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
`;

export const ThumbnailFileInput = styled(Input)`
  display: none;
`;

export const UploadBtnContainer = styled.div`
  text-align: right;
`;

export const UploadButton = styled(Button)``;
