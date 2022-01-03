import React from 'react';

function Button(props) {
  const { label } = props;
  return <button type='button'>{label}</button>;
}

export default Button;
