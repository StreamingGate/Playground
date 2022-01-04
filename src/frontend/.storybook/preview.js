import React from 'react';
import { ThemeProvider } from 'styled-components';

import { GlobalStyle, NormalizeStyle } from '@components/styles';
import { theme } from '@utils/constant';

export const decorators = [
  Story => (
    <ThemeProvider theme={theme}>
      <GlobalStyle />
      <NormalizeStyle />
      <Story />
    </ThemeProvider>
  ),
];
