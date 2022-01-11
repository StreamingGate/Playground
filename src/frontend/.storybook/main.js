const path = require('path');

function getAlias(config) {
  const { resolve } = config;
  resolve.alias['@'] = path.resolve(__dirname, '../src');
  resolve.alias['@assets'] = path.resolve(__dirname, '../src/assets');
  resolve.alias['@components'] = path.resolve(__dirname, '../src/components');
  resolve.alias['@pages'] = path.resolve(__dirname, '../src/pages');
  resolve.alias['@services'] = path.resolve(__dirname, '../src/services');
  resolve.alias['@utils'] = path.resolve(__dirname, '../src/utils');
}

module.exports = {
  stories: ['../src/**/*.stories.mdx', '../src/**/*.stories.@(js|jsx)'],
  addons: ['@storybook/addon-essentials', '@storybook/addon-a11y'],
  framework: '@storybook/react',
  core: {
    builder: 'webpack5',
  },
  webpackFinal: async (config, { configType }) => {
    getAlias(config);

    const webpackRules = config.module.rules;
    const fileLoader = webpackRules.find(rule => rule.test.test('.svg'));
    fileLoader.exclude = /\.svg$/i;

    webpackRules.push({
      test: /\.svg$/i,
      use: ['@svgr/webpack'],
    });

    return config;
  },
};
