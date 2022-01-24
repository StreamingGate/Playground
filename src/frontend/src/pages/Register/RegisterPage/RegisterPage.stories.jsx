import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from 'react-query';

import RegisterPage from './RegisterPage';

const queryClient = new QueryClient();

export default {
  title: 'Page/Register',
  component: RegisterPage,
  parameters: {
    layout: 'fullscreen',
    controls: { hideNoControlsWarning: true, exclude: ['path'] },
  },
  decorators: [
    Story => (
      <QueryClientProvider client={queryClient}>
        <Router>
          <Story />
        </Router>
      </QueryClientProvider>
    ),
  ],
};

const Template = args => <RegisterPage {...args} />;

export const Register = Template.bind({});
