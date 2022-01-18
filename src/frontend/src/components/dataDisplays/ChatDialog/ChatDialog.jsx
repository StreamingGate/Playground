import React, { memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './ChatDialog.style';

function ChatDialog({ chatInfo, isAdmin }) {
  const { profileImgSrc, timeStamp, userName, message } = chatInfo;
  return (
    <S.ChatDialogContainer>
      <S.ChatMetaContainer>
        <S.ChatProfile size='md' isAdmin={isAdmin} />
        <S.TimeStamp type='bottomTab'>{timeStamp}</S.TimeStamp>
        <S.UserName type='highlightCaption'>{userName}</S.UserName>
      </S.ChatMetaContainer>
      <S.Message>{message}</S.Message>
    </S.ChatDialogContainer>
  );
}

ChatDialog.propTypes = {
  chatInfo: PropTypes.shape({
    profileImgSrc: PropTypes.string,
    timeStamp: PropTypes.instanceOf(Date),
    userName: PropTypes.string,
    message: PropTypes.string,
  }).isRequired,
  isAdmin: PropTypes.bool,
};

ChatDialog.defaultProps = {
  isAdmin: false,
};

export default memo(ChatDialog);
