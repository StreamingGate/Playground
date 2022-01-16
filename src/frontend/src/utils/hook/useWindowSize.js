import { useState, useEffect } from 'react';

function getWindowSize() {
  const { innerWidth, innerHeight } = window;
  return {
    innerWidth,
    innerHeight,
  };
}

export default function useWindowDimensions() {
  const [windowSize, setWindowSize] = useState(getWindowSize());

  useEffect(() => {
    function handleResizeWindow() {
      setWindowSize(getWindowSize());
    }

    window.addEventListener('resize', handleResizeWindow);
    return () => window.removeEventListener('resize', handleResizeWindow);
  }, []);

  return windowSize;
}
