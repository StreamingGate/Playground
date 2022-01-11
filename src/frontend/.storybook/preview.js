import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom';
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
  Story => (
    <div style={{ display: 'flex', alignItems: 'flex-end', gap: '10px' }}>
      <Story />
    </div>
  ),
  Story => (
    <Router>
      <Story />
    </Router>
  ),
];

export const parameters = { layout: 'fullscreen' };
