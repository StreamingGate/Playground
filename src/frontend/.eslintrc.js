module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  extends: [
    'airbnb',
    'airbnb/hooks',
    'plugin:storybook/recommended',
    'plugin:prettier/recommended',
  ],
  rules: {
    'import/no-unresolved': 'off',
    'import/extensions': 'off',
    'react/jsx-props-no-spreading': 'off',
    'react-hooks/exhaustive-deps': 'off',
    'import/order': 'off',
    'import/prefer-default-export': 'off',
    'no-param-reassign': 'off',
    'react/function-component-definition': 'off',
    'react/prop-types': 'off',
    'no-shadow': 'off',
    'default-param-last': 'off',
    'react/forbid-prop-types': 'off',
  },
  overrides: [
    {
      files: ['*.stories.@(js|jsx)'],
      rules: {
        'react/function-component-definition': 'off',
        'react/jsx-props-no-spreading': 'off',
        'react/jsx-no-constructed-context-values': 'off',
      },
    },
  ],
};
