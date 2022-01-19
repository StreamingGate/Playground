import React from 'react';

import Person from '@assets/icons/Person.svg';

import withSvgIcon from './withSvgIcon';

function CustomPerson(props) {
  return <Person {...props} />;
}

export default withSvgIcon(CustomPerson);
