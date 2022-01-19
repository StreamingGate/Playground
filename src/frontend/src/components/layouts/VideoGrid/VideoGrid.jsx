import React from 'react';
import Proptypes from 'prop-types';
import styled from 'styled-components';

function VideoGrid({ className, children }) {
  return <VideoContainer className={className}>{children}</VideoContainer>;
}

VideoGrid.propTypes = {
  className: Proptypes.string,
  children: Proptypes.element.isRequired,
};

VideoGrid.defaultProps = {
  className: '',
};

const VideoContainer = styled.ul`
  display: grid;
  grid-template-columns: repeat(var(--video-num-in-a-row), 1fr);
  grid-gap: 22px;
`;

export default VideoGrid;
