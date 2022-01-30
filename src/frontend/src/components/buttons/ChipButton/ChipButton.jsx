import React, { forwardRef, memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './ChipButton.style';

const ChipButton = forwardRef((props, ref) => {
  const { content, isSelected, onClick } = props;
  return (
    <S.ChipButton ref={ref} isSelected={isSelected} onClick={onClick}>
      {content}
    </S.ChipButton>
  );
});

ChipButton.propTypes = {
  content: PropTypes.string.isRequired,
  isSelected: PropTypes.bool,
  onClick: PropTypes.func,
};

ChipButton.defaultProps = {
  isSelected: false,
  onClick: undefined,
};

export default memo(ChipButton);
