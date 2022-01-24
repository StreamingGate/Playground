import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom';
import { QueryClientProvider, QueryClient } from 'react-query';

import LoginPage from './LoginPage';

const queryClient = new QueryClient();

export default {
  title: 'Page/Login',
  component: LoginPage,
  parameters: { controls: { hideNoControlsWarning: true } },
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

const Template = args => <LoginPage {...args} />;

export const Login = Template.bind({});
Login.parameters = {
  layout: 'fullscreen',
};
