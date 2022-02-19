import React, { memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './ChatDialog.style';
import { timeService } from '@utils/service';

function ChatDialog({ chatInfo, isPinned }) {
  const { timeStamp, nickname, message, senderRole, profileImage } = chatInfo;

  return (
    <S.ChatDialogContainer>
      <S.ChatMetaContainer>
        <S.ChatProfile size='md' isAdmin={senderRole === 'STREAMER'} imgSrc={profileImage} />
        {isPinned && <S.PinText type='highlightCaption'>상단고정</S.PinText>}
        {!isPinned && (
          <S.TimeStamp type='bottomTab'>{timeService.processChatTime(timeStamp)}</S.TimeStamp>
        )}
        <S.UserName type='highlightCaption'>{nickname}</S.UserName>
      </S.ChatMetaContainer>
      <S.Message>{message}</S.Message>
    </S.ChatDialogContainer>
  );
}

ChatDialog.propTypes = {
  chatInfo: PropTypes.shape({
    profileImgSrc: PropTypes.string,
    timeStamp: PropTypes.string,
    nickname: PropTypes.string,
    message: PropTypes.string,
    senderRole: PropTypes.oneOf(['STREAMER', 'VIEWER']),
  }).isRequired,
  isPinned: PropTypes.bool,
};

ChatDialog.defaultProps = {
  isPinned: false,
};

export default memo(ChatDialog);
