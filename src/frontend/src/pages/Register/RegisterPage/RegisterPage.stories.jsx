import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom';

import RegisterPage from './RegisterPage';

export default {
  title: 'Page/Register',
  component: RegisterPage,
  parameters: {
    layout: 'fullscreen',
    controls: { hideNoControlsWarning: true, exclude: ['path'] },
  },
  decorators: [
    Story => (
      <Router>
        <Story />
      </Router>
    ),
  ],
};

const Template = args => <RegisterPage {...args} />;

export const Register = Template.bind({});
