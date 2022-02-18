const setItem = (key, item) => {
  localStorage.setItem(key, item);
};

const getItem = key => {
  return localStorage.getItem(key);
};

const removeItem = key => {
  localStorage.removeItem(key);
};

export default { setItem, getItem, removeItem };
