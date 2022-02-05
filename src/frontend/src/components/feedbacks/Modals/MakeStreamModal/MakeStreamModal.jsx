import React from 'react';
import PropTypes from 'prop-types';

import * as S from './MakeStreamModal.style';
import { modalService } from '@utils/service';
import { Dialog } from '@components/feedbacks';

function MakeStreamModal({ type }) {
  const modal = modalService.useModal();
  return (
    <Dialog open={modal.visible} maxWidth='md' zIndex={2}>
      <S.MakeStreamModalContainer>
        <S.StreamModalTitleContainer>
          <S.StreamModalTitle>스트림 만들기</S.StreamModalTitle>
        </S.StreamModalTitleContainer>
        <S.StreamModalBody>
          <S.StreamInfoContainer>
            <S.VideoSelectContainer>
              <S.InputLabel>동영상 선택</S.InputLabel>
              <S.VideoPreviewContainer>
                <S.VideoPreview />
                <S.VideoSelectBtn color='pgBlue'>파일선택</S.VideoSelectBtn>
                <S.VideoFileInput type='file' />
              </S.VideoPreviewContainer>
            </S.VideoSelectContainer>
            <S.VideoDetailInfoContainer>
              <S.InputLabel>세부정보</S.InputLabel>
              <S.VideoTitleInput multiLine fullWidth placeholder='제목' rows='2' />
              <S.VideoContentInput multiLine fullWidth placeholder='내용' rows='3' />
            </S.VideoDetailInfoContainer>
          </S.StreamInfoContainer>
          <S.CategorySelectContainer>
            <S.InputLabel>카테고리</S.InputLabel>
            <select>
              <option>ALL</option>
              <option>EDU</option>
              <option>SPORTS</option>
              <option>KPOP</option>
            </select>
          </S.CategorySelectContainer>
          <S.ThumbnailSelectContainer>
            <S.InputLabel>썸네일 이미지 (선택)</S.InputLabel>
            <S.InputSubLabel type='caption'>
              * 썸네일 이미지를 선택하지 않으면 랜덤으로 추출합니다
            </S.InputSubLabel>
            <S.ThumbnailPreviewContainer>
              <S.ThumbnailPreview>
                <S.CameraIcon />
              </S.ThumbnailPreview>
              <S.ThumbnailFileInput type='file' />
            </S.ThumbnailPreviewContainer>
          </S.ThumbnailSelectContainer>
          <S.UploadBtnContainer>
            <S.UploadButton color='pgBlue' size='md'>
              업로드
            </S.UploadButton>
          </S.UploadBtnContainer>
        </S.StreamModalBody>
      </S.MakeStreamModalContainer>
    </Dialog>
  );
}

MakeStreamModal.propTypes = {
  type: PropTypes.string.isRequired,
};

export default modalService.create(MakeStreamModal);
