import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom';

import LoginPage from './LoginPage';

export default {
  title: 'Page/Login',
  component: LoginPage,
  parameters: { controls: { hideNoControlsWarning: true } },
  decorators: [
    Story => (
      <Router>
        <Story />
      </Router>
    ),
  ],
};

const Template = args => <LoginPage {...args} />;

export const Login = Template.bind({});
Login.parameters = {
  layout: 'fullscreen',
};
