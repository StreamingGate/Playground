import React, { useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import PropTypes from 'prop-types';
import { v4 as uuidv4 } from 'uuid';

import * as S from './MakeStreamModal.style';
import { useForm } from '@utils/hook';
import { useUploadVideo, useMakeLive } from '@utils/hook/query';
import { modalService, mediaService, lStorageService } from '@utils/service';

import { Dialog } from '@components/feedbacks';
import { AdviseModal } from '@components/feedbacks/Modals';

const TITLE_MAX_LEN = 100;
const CONTENT_MAX_LEN = 5000;

function MakeStreamModal({ type }) {
  const videoInputRef = useRef(null);
  const thumbnailInputRef = useRef(null);
  const userId = lStorageService.getItem('uuid');

  const navigate = useNavigate();

  const { mutate } = useUploadVideo();

  const { values, handleInputChange } = useForm({ initialValues: { title: '', content: '' } });
  const modal = modalService.useModal();

  const [category, setCategory] = useState('');
  const [filePreview, setFilePreview] = useState({ videoUrl: '', thumbnailUrl: '' });
  const [fileFormData, setFileFormData] = useState({ video: null, thumbnail: null });

  const handleFileSelectBtn = e => {
    const { id } = e.currentTarget;

    let button = null;

    if (id === 'videoSelect') {
      button = e.target.closest('video');
      if (button) {
        videoInputRef.current.click();
      }
    } else if (id === 'thumbnailSelect') {
      button = e.target.closest('div');
      if (button) {
        thumbnailInputRef.current.click();
      }
    }
  };

  const handleFileInputChange = async e => {
    const { target } = e;
    if (target.id === 'videoFile') {
      const videoUrl = URL.createObjectURL(target.files[0]);
      setFilePreview(prev => ({ ...prev, videoUrl }));
      setFileFormData(prev => ({ ...prev, video: target.files[0] }));
    } else if (target.id === 'thumbnailFile') {
      const thumbnailUrl = await mediaService.getImagePreviewURl(thumbnailInputRef.current);
      setFilePreview(prev => ({ ...prev, thumbnailUrl }));
      setFileFormData(prev => ({ ...prev, thumbnail: target.files[0] }));
    }
  };

  const handleCategoryChange = e => {
    const { target } = e;
    setCategory(target.value);
  };

  const handleUploadBtnClick = () => {
    const { title, content } = values;
    const modalProps = {};

    if (!title || !content || !filePreview.videoUrl || !category) {
      modalProps.content = '썸네일을 제외한 모든 필드는 필수값 입니다';
    } else if (title.length > TITLE_MAX_LEN || content.length > CONTENT_MAX_LEN) {
      modalProps.content = '글자수를 초과했습니다';
    }

    if (Object.keys(modalProps).length !== 0) {
      modalService.show(AdviseModal, { ...modalProps });
      return;
    }

    const formData = new FormData();
    formData.append('video', fileFormData.video);

    if (fileFormData.thumbnail) {
      formData.append('thumbnail', fileFormData.thumbnail);
    }

    formData.append(
      'data',
      new Blob(
        [JSON.stringify({ title, content, category, uuid: '33333333-1234-1234-123456789012' })],
        { type: 'application/json' }
      )
    );

    mutate(formData);
  };

  const handleMakeLiveSuccess = data => {
    const { uuid, _ } = data;
    modal.hide();
    navigate(`/studio/${uuid}`);
  };

  const { mutate: makeLive } = useMakeLive(handleMakeLiveSuccess);

  const handleStartLiveBtnClick = () => {
    const { title, content } = values;
    const modalProps = {};

    if (!title || !content || !category || !filePreview.thumbnailUrl) {
      modalProps.content = '모든 필드는 필수값 입니다';
    } else if (title.length > TITLE_MAX_LEN || content.length > CONTENT_MAX_LEN) {
      modalProps.content = '글자수를 초과했습니다';
    }

    if (Object.keys(modalProps).length !== 0) {
      modalService.show(AdviseModal, { ...modalProps });
      return;
    }

    makeLive({
      hostUuid: userId,
      category,
      uuid: uuidv4(),
      title,
      content,
      thumbnail: filePreview.thumbnailUrl.split(',')[1],
    });
  };

  return (
    <Dialog open={modal.visible} maxWidth='md' zIndex={2} onClose={() => modal.hide()}>
      <S.MakeStreamModalContainer onClick={e => e.stopPropagation()}>
        <S.StreamModalTitleContainer>
          <S.StreamModalTitle>스트림 만들기</S.StreamModalTitle>
        </S.StreamModalTitleContainer>
        <S.StreamModalBody>
          <S.StreamInfoContainer>
            {type === 'video' && (
              <S.VideoSelectContainer>
                <S.InputLabel>동영상 선택</S.InputLabel>
                <S.VideoPreviewContainer>
                  <S.VideoPreview
                    id='videoSelect'
                    src={filePreview.videoUrl}
                    autoPlay
                    controls={filePreview.videoUrl && true}
                    onClick={handleFileSelectBtn}
                  />
                  <S.VideoIcon />
                  <S.VideoFileInput
                    id='videoFile'
                    type='file'
                    accept='.mp4'
                    ref={videoInputRef}
                    onChange={handleFileInputChange}
                  />
                </S.VideoPreviewContainer>
              </S.VideoSelectContainer>
            )}
            <S.VideoDetailInfoContainer>
              <S.InputLabel>세부정보</S.InputLabel>
              <S.InputContainer>
                <S.VideoTitleInput
                  multiLine
                  fullWidth
                  placeholder='제목'
                  rows='2'
                  name='title'
                  value={values.title}
                  onChange={handleInputChange}
                />
                <S.InputCount type='caption' isLimit={values.title.length > TITLE_MAX_LEN}>
                  {values.title.length} / {TITLE_MAX_LEN}
                </S.InputCount>
              </S.InputContainer>
              <S.InputContainer>
                <S.VideoContentInput
                  multiLine
                  fullWidth
                  placeholder='설명'
                  rows='3'
                  name='content'
                  value={values.content}
                  onChange={handleInputChange}
                />
                <S.InputCount type='caption' isLimit={values.content.length > CONTENT_MAX_LEN}>
                  {values.content.length} / {CONTENT_MAX_LEN}
                </S.InputCount>
              </S.InputContainer>
            </S.VideoDetailInfoContainer>
          </S.StreamInfoContainer>
          <S.CategorySelectContainer>
            <S.InputLabel>카테고리</S.InputLabel>
            <S.CategorySelect value={category} onChange={handleCategoryChange}>
              <option value=''>카테고리를 선택해주세요</option>
              <option value='ALL'>ALL</option>
              <option value='EDU'>EDU</option>
              <option value='SPORTS'>SPORTS</option>
              <option value='KPOP'>KPOP</option>
            </S.CategorySelect>
          </S.CategorySelectContainer>
          <S.ThumbnailSelectContainer>
            <S.InputLabel>썸네일 이미지 {type === 'video' && '(선택)'}</S.InputLabel>
            {type === 'video' && (
              <S.InputSubLabel type='caption'>
                * 썸네일 이미지를 선택하지 않으면 랜덤으로 추출합니다
              </S.InputSubLabel>
            )}
            <S.ThumbnailPreviewContainer>
              <S.ThumbnailPreview
                id='thumbnailSelect'
                src={filePreview.thumbnailUrl}
                onClick={handleFileSelectBtn}
              >
                <S.CameraIcon />
              </S.ThumbnailPreview>
              <S.ThumbnailFileInput
                id='thumbnailFile'
                type='file'
                accept='.jpg, .jpeg, .png'
                ref={thumbnailInputRef}
                onChange={handleFileInputChange}
              />
            </S.ThumbnailPreviewContainer>
          </S.ThumbnailSelectContainer>
          <S.UploadBtnContainer>
            <S.UploadButton
              color='pgBlue'
              size='md'
              onClick={type === 'video' ? handleUploadBtnClick : handleStartLiveBtnClick}
            >
              {type === 'video' ? '업로드' : '스트리밍 시작'}
            </S.UploadButton>
          </S.UploadBtnContainer>
        </S.StreamModalBody>
      </S.MakeStreamModalContainer>
    </Dialog>
  );
}

MakeStreamModal.propTypes = {
  type: PropTypes.oneOf(['video', 'live']).isRequired,
};

export default modalService.create(MakeStreamModal);
