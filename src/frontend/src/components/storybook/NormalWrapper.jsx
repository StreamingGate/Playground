import React from 'react';
import PropTypes from 'prop-types';

function NormalWrapper({ children }) {
  return <div style={{ display: 'flex', alignItems: 'flex-end', gap: '10px' }}>{children}</div>;
}

NormalWrapper.propTypes = {
  children: PropTypes.element.isRequired,
};

export default NormalWrapper;
