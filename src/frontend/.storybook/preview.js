import React from 'react';
import { QueryClientProvider, QueryClient } from 'react-query';
import { ThemeProvider } from 'styled-components';

import { GlobalStyle, NormalizeStyle } from '@components/styles';
import { theme } from '@utils/constant';
import { modalService } from '@utils/service';

const queryClient = new QueryClient();

export const decorators = [
  Story => (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider theme={theme}>
        <GlobalStyle />
        <NormalizeStyle />
        <modalService.Provider>
          <Story />
        </modalService.Provider>
      </ThemeProvider>
    </QueryClientProvider>
  ),
];
