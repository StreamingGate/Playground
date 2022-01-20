import React, { memo } from 'react';
import Proptypes from 'prop-types';

import * as S from './Stepper.style';
import { theme } from '@utils/constant';

function Stepper({ step, inActiveColor, activeColor, width, spacing, activeStep }) {
  return (
    <S.StepperContainer
      step={step}
      inActiveColor={inActiveColor}
      activeColor={activeColor}
      width={width}
      spacing={spacing}
    >
      {new Array(step)
        .fill(0)
        .map((_, idx) => idx + 1)
        .map((elem, idx) => (
          <S.Step key={elem} isActive={activeStep >= idx + 1}>
            <S.StepContent type='highlightCaption'>{idx + 1}</S.StepContent>
          </S.Step>
        ))}
    </S.StepperContainer>
  );
}

Stepper.propTypes = {
  step: Proptypes.number.isRequired,
  inActiveColor: Proptypes.string,
  activeColor: Proptypes.string,
  width: Proptypes.string,
  spacing: Proptypes.string,
  activeStep: Proptypes.number,
};

Stepper.defaultProps = {
  activeColor: theme.colors.pgBlue,
  inActiveColor: theme.colors.pgMint,
  width: '20px',
  spacing: '5px',
  activeStep: 1,
};

export default memo(Stepper);
