import React from 'react';
import PropTypes from 'prop-types';

import * as S from './ChipButton.style';

function ChipButton({ content, isSelected }) {
  return <S.ChipButton isSelected={isSelected}>{content}</S.ChipButton>;
}

ChipButton.propTypes = {
  content: PropTypes.string.isRequired,
  isSelected: PropTypes.bool,
};

ChipButton.defaultProps = {
  isSelected: false,
};

export default ChipButton;
