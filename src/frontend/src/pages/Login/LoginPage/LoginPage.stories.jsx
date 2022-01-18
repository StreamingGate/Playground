import React from 'react';

import LoginPage from './LoginPage';

export default {
  title: 'Page/Login',
  component: LoginPage,
};

const Template = args => <LoginPage {...args} />;

export const Login = Template.bind({});
Login.parameters = {
  layout: 'fullscreen',
};
