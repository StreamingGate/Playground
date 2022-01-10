const screenSize = {
  tablet: 1023.99,
  mobile: 767.99,
};

const queries = {
  tabletMax: `max-width: ${screenSize.tablet / 16}rem`,
  mobileMax: `max-width: ${screenSize.mobile / 16}rem`,
};

export default queries;
