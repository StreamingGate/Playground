import axios from 'axios';
import { history } from '@utils/router';

const axiosInstance = axios.create({ baseURL: process.env.REACT_APP_API });

axiosInstance.interceptors.request.use(
  config => {
    config.headers.Authorization =
      'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIzMzMzMzMzMy0xMjM0LTEyMzQtMTIzNDU2Nzg5MDEyIiwiZXhwIjoxNjQ0NTAwMDQ4fQ.8tUJ5Akh4TT5Uc2u9RqXtZAbIqSC8fLYputpM0DBr4sSbaPuy6nW7XAwGTuMmM48cScolYPxih-yw3-4AHwwHQ';
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
    if (error.response.status === 401) {
      history.push('/login');
      history.go();
    }
    return Promise.reject(error);
  }
);

export default axiosInstance;
