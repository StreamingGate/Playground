import React from 'react';

import { GlobalStyle, NormalizeStyle } from '@components/styles';

export const decorators = [
  Story => (
    <>
      <GlobalStyle />
      <NormalizeStyle />
      <Story />
    </>
  ),
];
