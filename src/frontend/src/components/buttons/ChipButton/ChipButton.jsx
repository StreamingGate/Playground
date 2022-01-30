import React, { forwardRef, memo } from 'react';
import PropTypes from 'prop-types';

import * as S from './ChipButton.style';

const ChipButton = forwardRef((props, ref) => {
  const { content, isSelected } = props;
  return (
    <S.ChipButton ref={ref} isSelected={isSelected}>
      {content}
    </S.ChipButton>
  );
});

ChipButton.propTypes = {
  content: PropTypes.string.isRequired,
  isSelected: PropTypes.bool,
};

ChipButton.defaultProps = {
  isSelected: false,
};

export default memo(ChipButton);
