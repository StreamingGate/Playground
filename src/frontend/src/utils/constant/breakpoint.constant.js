const screenSize = {
  wideLaptop: 1200,
  laptop: 1023.99,
  tablet: 767.99,
  mobile: 450,
  minSize: 300,
};

const queries = {
  wideLaptop: `max-width ${screenSize.wideLaptop / 16}rem`,
  laptopMax: `max-width: ${screenSize.laptop / 16}rem`,
  tabletMax: `max-width: ${screenSize.tablet / 16}rem`,
  mobileMax: `max-width: ${screenSize.mobile / 16}rem`,
};

const breakPoint = { queries, screenSize };

export default breakPoint;
