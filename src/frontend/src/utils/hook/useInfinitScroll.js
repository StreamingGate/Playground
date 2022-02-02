import { useEffect, useRef, useCallback } from 'react';

export default function useInifinitScroll(callback, option) {
  const observer = useRef(null);

  const handleObserver = useCallback(entries => {
    const target = entries[0];
    if (target.isIntersecting) {
      callback();
    }
  }, []);

  useEffect(() => {
    observer.current = new IntersectionObserver(handleObserver, option);
  }, []);

  return observer.current;
}
