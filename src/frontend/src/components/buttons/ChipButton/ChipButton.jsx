import React from 'react';
import PropTypes from 'prop-types';

import * as S from './ChipButton.style';

function ChipButton({ content }) {
  return <S.ChipButton>{content}</S.ChipButton>;
}

ChipButton.propTypes = {
  content: PropTypes.string.isRequired,
};

export default ChipButton;
