import axios from 'axios';
import { history } from '@utils/router';

import { lStorageService } from '@utils/service';

const axiosInstance = axios.create({ baseURL: process.env.REACT_APP_API });

axiosInstance.interceptors.request.use(
  config => {
    const token = lStorageService.getItem('token');
    const uuid = lStorageService.getItem('uuid');
    const nickName = lStorageService.getItem('nickName');
    const profileImage = lStorageService.getItem('profileImage');

    // token, uuid가 없을시 로그인 페이지로 리다이렉트
    if (!token || !uuid || !nickName || !profileImage) {
      alert('here');
      history.push('/login');
      history.go();
    }
    config.headers.Authorization = `Bearer ${token}`;
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
