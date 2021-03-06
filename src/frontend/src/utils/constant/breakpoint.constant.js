/**
 * 반응형 스크린 사이즈 지정을 위한 객체
 */

const screenSize = {
  wideLaptop: 1440,
  laptop: 1024,
  tablet: 768,
  mobile: 500,
  minSize: 350,
};

const queries = {
  wideLaptop: `max-width: ${screenSize.wideLaptop / 16}rem`,
  laptopMax: `max-width: ${screenSize.laptop / 16}rem`,
  tabletMax: `max-width: ${screenSize.tablet / 16}rem`,
  mobileMax: `max-width: ${screenSize.mobile / 16}rem`,
};

const breakPoint = { queries, screenSize };

export default breakPoint;
