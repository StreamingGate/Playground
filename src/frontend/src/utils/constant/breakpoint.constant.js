const screenSize = {
  laptop: 1023.99,
  tablet: 767.99,
  mobile: 450,
  minSize: 300,
};

const queries = {
  laptopMax: `max-width: ${screenSize.laptop / 16}rem`,
  tabletMax: `max-width: ${screenSize.tablet / 16}rem`,
  mobileMax: `max-width: ${screenSize.mobile / 16}rem`,
};

const breakPoint = { queries, screenSize };

export default breakPoint;
