import React from 'react';

import RegisterPage from './RegisterPage';

export default {
  title: 'Page/Register',
  component: RegisterPage,
  parameters: {
    layout: 'fullscreen',
    controls: { hideNoControlsWarning: true, exclude: ['path'] },
  },
};

const Template = args => <RegisterPage {...args} />;

export const Register = Template.bind({});
