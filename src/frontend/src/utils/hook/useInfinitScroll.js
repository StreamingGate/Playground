/**
 *
 * @param {Function} callback 기준에 도달했을 때 실행될 함수
 * @param {Object} option IntersectionObserver option
 * @returns
 */

export default function useInifinitScroll(callback, option) {
  const handleObserver = entries => {
    const target = entries[0];
    if (target.isIntersecting && callback) {
      callback();
    }
  };

  return new IntersectionObserver(handleObserver, option);
}
