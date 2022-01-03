import React from 'react';

import Button from './Button';

export default {
  title: 'Components/Forms',
  component: Button,
};

const Template = args => <Button {...args} />;

export const Default = Template.bind({});
Default.args = {
  label: 'Test',
};
