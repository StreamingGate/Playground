import React, { memo } from 'react';
import PropTypes from 'prop-types';
import styled, { css } from 'styled-components';

const getSvgIconSize = size => {
  switch (size) {
    case 'large':
      return css`
        width: 36px;
        height: 36px;
        min-width: 36px;
      `;
    // default size is 'small'
    default:
      return css`
        width: 24px;
        height: 24px;
        min-width: 24px;
      `;
  }
};

function withSvgIcon(SvgIcon) {
  function SubComponent({ size, ...rest }) {
    return <Temp size={size} {...rest} />;
  }

  const Temp = styled(SvgIcon)`
    ${({ size }) => getSvgIconSize(size)}
  `;

  SubComponent.propTypes = {
    size: PropTypes.oneOf(['small', 'large']),
  };

  SubComponent.defaultProps = {
    size: 'small',
  };

  return memo(SubComponent);
}

export default withSvgIcon;
