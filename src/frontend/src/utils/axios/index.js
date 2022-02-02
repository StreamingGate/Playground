import axios from 'axios';

const axiosInstance = axios.create({ baseURL: process.env.REACT_APP_API });

axiosInstance.interceptors.request.use(
  config => {
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

axiosInstance.interceptors.response.use(
  response => {
    return response.data;
  },
  error => {
    return Promise.reject(error);
  }
);

export default axiosInstance;
