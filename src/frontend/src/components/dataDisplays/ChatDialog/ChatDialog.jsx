import React, { memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './ChatDialog.style';
import { timeService } from '@utils/service';

function ChatDialog({ chatInfo }) {
  const { timeStamp, nickname, message, senderRole, profileImage } = chatInfo;
  return (
    <S.ChatDialogContainer>
      <S.ChatMetaContainer>
        <S.ChatProfile size='md' isAdmin={senderRole === 'STREAMER'} imgSrc={profileImage} />
        <S.TimeStamp type='bottomTab'>{timeService.processChatTime(timeStamp)}</S.TimeStamp>
        <S.UserName type='highlightCaption'>{nickname}</S.UserName>
      </S.ChatMetaContainer>
      <S.Message>{message}</S.Message>
    </S.ChatDialogContainer>
  );
}

ChatDialog.propTypes = {
  chatInfo: PropTypes.shape({
    profileImgSrc: PropTypes.string,
    timeStamp: PropTypes.instanceOf(Date),
    nickname: PropTypes.string,
    message: PropTypes.string,
    senderRole: PropTypes.oneOf(['STREAMER', 'VIEWER']),
  }).isRequired,
};

export default memo(ChatDialog);
