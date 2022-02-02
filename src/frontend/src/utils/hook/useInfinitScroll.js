export default function useInifinitScroll(callback, option) {
  const handleObserver = entries => {
    const target = entries[0];
    if (target.isIntersecting && callback) {
      callback();
    }
  };

  return new IntersectionObserver(handleObserver, option);
}
